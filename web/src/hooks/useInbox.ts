'use client'
import { getAllInboxes, getMessage, isReadInboxes, saveMessage } from '@/service/chat';
import { useAuthStore } from '@/stores';
import { useChatStore } from '@/stores/chat.store';
import useInboxStore, { inboxActions } from '@/stores/inbox.store';
import { useCallback, useEffect, useState } from 'react';

const useInbox = (messageRef: React.RefObject<HTMLElementTagNameMap['div'] | null>) => {
    const { user_id } = useAuthStore()
    const [messageInput, setMessageInput] = useState<string>("")

    const [inboxPage, setInboxPage] = useState<number>(1)
    const [messagePage, setMessagePage] = useState<number>(1)
    const [chatID, setChatID] = useState<string>("")

    const messages = useChatStore((state) => state.messages);
    const resetChat = useChatStore((state) => state.reset);

    const inboxes = useInboxStore((state) => state.inboxes);
    const resetInbox = useInboxStore((state) => state.reset);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const setMessages = useChatStore((state) => state.setMessages);
    const appendMessages = useChatStore((state) => state.appendMessages);
    const onReceiveMessage = useChatStore((state) => state.onReceiveMessage);
    const seenSent = useInboxStore((state) => state.seenSent);
    const setSeen = useInboxStore((state) => state.setSeen);

    const handleSendMessage = async () => {
        if (!messageInput.trim() || !chatID) return;

        const inbox = inboxes.find((i) => i._id === chatID);
        if (!inbox) return;

        const receiver_id = inbox.user_id;
        const result = await saveMessage(messageInput.trim(), chatID, receiver_id._id);
        if (result) {
            onReceiveMessage({
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

    const fetchInboxes = useCallback(async (currentPage: number) => {
        setLoading(true);
        setError(null);

        const inboxes = await getAllInboxes(currentPage);

        if (typeof inboxes === 'string') {
            inboxActions.setInboxes([]);
            setError(inboxes);
        } else {
            inboxActions.setInboxes(inboxes);
            setChatID(inboxes[0]._id)
        }
        setLoading(false);
    }, []);

    const fetchMessages = useCallback(async (chat_id: string, currentPage: number) => {
        setLoading(true);
        setError(null);

        const messages = await getMessage(chat_id, currentPage);

        if (typeof messages === 'string') {
            setMessages(chat_id, []);
            setError(messages);
        } else {
            if (currentPage > 1) {
                appendMessages(chat_id, messages);
            } else {
                setMessages(chat_id, messages);
            }
        }
        setLoading(false);
    }, [setMessages, appendMessages]);

    useEffect(() => {
        fetchInboxes(inboxPage)
    }, [inboxPage, fetchInboxes])

    useEffect(() => {
        if (chatID) fetchMessages(chatID, messagePage)
    }, [chatID, messagePage, fetchMessages])


    useEffect(() => {
        const container = messageRef.current;
        if (!container) return;
        const handleScroll = () => {
            const isAtTop = container.scrollHeight + container.scrollTop - container.clientHeight <= 5;
            if (isAtTop) {
                setMessagePage((prev) => prev + 1);
            }
        };

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
        };
    }, [messageRef]);

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

    return { messageInput, setMessageInput, handleSendMessage, inboxPage, setInboxPage, messagePage, setMessagePage, chatID, setChatID, messages, resetChat, inboxes, resetInbox, loading, setLoading, error, setError };
}

export default useInbox