'use client'
import { getAllInboxes, getMessage, isReadInboxes, saveMessage } from '@/service/chat';
import { useAuthStore } from '@/stores';
import { chatActions, useChatStore } from '@/stores/chat.store';
import useInboxStore, { inboxActions } from '@/stores/inbox.store';
import { useCallback, useEffect, useRef, useState } from 'react';

const useInbox = (messageRef: React.RefObject<HTMLElementTagNameMap['div'] | null>) => {
    const { user_id } = useAuthStore()
    const [messageInput, setMessageInput] = useState<string>("")

    const [inboxCursor, setInboxCursor] = useState<string | null>(null)
    const lastFetchedCursor = useRef<string | null>(null);
    const hasLoadedInboxes = useRef(false);
    const [messageCursor, setMessageCursor] = useState<string | null>(null)
    const lastFetchedCursorMessages = useRef<string | null>(null);
    const hasLoadedMessages = useRef(false);
    const [chatID, setChatID] = useState<string>("")

    const messages = useChatStore((state) => state.messages);
    const resetChat = useChatStore((state) => state.reset);

    const inboxes = useInboxStore((state) => state.inboxes);
    const resetInbox = useInboxStore((state) => state.reset);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const seenSent = useInboxStore((state) => state.seenSent);
    const setSeen = useInboxStore((state) => state.setSeen);

    const handleSendMessage = async () => {
        if (!messageInput.trim() || !chatID) return;

        const inbox = inboxes.find((i) => i._id === chatID);
        if (!inbox) return;

        const receiver_id = inbox.user_id;
        const result = await saveMessage(messageInput.trim(), chatID, receiver_id._id);
        if (result) {
            chatActions.onReceiveMessage({
                chat_id: chatID,
                sender_id: user_id,
                message: messageInput,
                isRead: false,
                createdAt: new Date().toString(),
                updatedAt: new Date().toString(),
            });
            setMessageInput('');
        } else {
            console.error('Failed to send message:', result);
        }
    };
    const fetchInboxes = useCallback(async (cursor?: string | null) => {
        setLoading(true);
        setError(null);

        const inboxes = await getAllInboxes(cursor || undefined);


        if (typeof inboxes === 'string') {
            inboxActions.setInboxes([]);
            setError(inboxes);
        } else {
            setInboxCursor(inboxes["nextCursor"]);
            if (cursor) {
                inboxActions.setInboxes((prev) => [...prev, ...inboxes["inboxes"]]);
                lastFetchedCursor.current = cursor;
            } else {
                inboxActions.setInboxes(inboxes["inboxes"]);
                setChatID(inboxes["inboxes"][0]._id);
                lastFetchedCursor.current = null;
                hasLoadedInboxes.current = true;
            }
        }
        setLoading(false);
    }, []);

    const fetchMessages = useCallback(async (chat_id: string, cursor?: string | null) => {
        setLoading(true);
        setError(null);

        const messages = await getMessage(chat_id, cursor || undefined);

        if (typeof messages === 'string') {
            chatActions.setMessages(chat_id, []);
            setError(messages);
        } else {
            console.log(messages["nextCursor"])
            setMessageCursor(messages["nextCursor"]);
            if (cursor) {
                chatActions.appendMessages(chat_id, messages["result"]);
                lastFetchedCursorMessages.current = cursor;
            } else {
                chatActions.setMessages(chat_id, messages["result"]);
                lastFetchedCursorMessages.current = null;
                hasLoadedMessages.current = true;
            }
        }
        setLoading(false);
    }, []);

    useEffect(() => {
        if (!hasLoadedInboxes.current && inboxes.length === 0) {
            fetchInboxes()
        }
    }, [fetchInboxes, inboxes.length])

    const loadMoreInboxes = useCallback(() => {
        if (inboxCursor && !loading && inboxCursor !== lastFetchedCursor.current) {
            fetchInboxes(inboxCursor);
        }
    }, [inboxCursor, loading, fetchInboxes]);

    useEffect(() => {
        if (chatID) fetchMessages(chatID)
    }, [chatID, fetchMessages])

    const loadMoreMessages = useCallback(() => {
        console.log("Im running 1", messageCursor)
        if (messageCursor && !loading && messageCursor !== lastFetchedCursorMessages.current) {
            console.log("Im running 2")
            fetchMessages(chatID, messageCursor)
        }
    }, [messageCursor, loading, fetchMessages, chatID]);

    useEffect(() => {
        const container = messageRef.current;
        if (!container) return;
        const handleScroll = () => {
            const isAtTop = container.scrollHeight + container.scrollTop - container.clientHeight <= 5;
            if (isAtTop) {
                loadMoreMessages();
            }
        };

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
        };
    }, [messageRef, loadMoreMessages]);

    useEffect(() => {
        const container = messageRef.current;
        if (!container || !chatID) return;

        const handleScroll = async () => {
            const isNearBottom = container.scrollTop >= 0;
            const inbox = useInboxStore.getState().inboxes.find((i) => i._id === chatID);
            const isAlreadyRead = inbox?.last_message?.isRead;

            if (isNearBottom && !isAlreadyRead && !seenSent[chatID]) {
                const success = await isReadInboxes(chatID);
                if (success) {
                    useInboxStore.getState().setInboxes((prev) =>
                        prev.map((inbox) =>
                            inbox._id === chatID
                                ? {
                                    ...inbox,
                                    last_message: {
                                        ...inbox.last_message,
                                        isRead: true,
                                    },
                                }
                                : inbox
                        )
                    );
                    setSeen(chatID, true);
                }
            }
        };

        container.addEventListener('scroll', handleScroll);
        return () => container.removeEventListener('scroll', handleScroll);
    }, [chatID, messageRef, seenSent, setSeen]);

    return { messageInput, setMessageInput, handleSendMessage, loadMoreMessages, chatID, setChatID, messages, resetChat, inboxes, resetInbox, loading, setLoading, error, setError, loadMoreInboxes, setMessageCursor };
}

export default useInbox