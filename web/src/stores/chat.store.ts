import { create } from 'zustand';
import { Message } from '@/types';


interface ChatState {
    messages: Record<string, Message[]>;
    setMessages: (chat_id: string, messages: Message[]) => void;
    appendMessages: (chat_id: string, messages: Message[]) => void;
    onReceiveMessage: (msg: Message) => void;
    reset: () => void;
}

export const useChatStore = create<ChatState>((set, get) => ({
    messages: {},
    setMessages: (chat_id, newMessages) => {
        set((state) => ({
            messages: {
                ...state.messages,
                [chat_id]: newMessages,
            },
        }));
    },
    appendMessages: (chat_id, newMessages) => {
        const current = get().messages[chat_id] || [];
        const existingIds = new Set(current.map((m) => m._id));
        const filteredNew = newMessages.filter((m) => !existingIds.has(m._id));

        set({
            messages: {
                ...get().messages,
                [chat_id]: [...current, ...filteredNew],
            },
        });
    },
    onReceiveMessage: (msg) => {
        console.log("hello")
        const current = get().messages[msg.chat_id] || [];
        set({
            messages: {
                ...get().messages,
                [msg.chat_id]: [msg, ...current],
            },
        });
    },
    reset: () => set({ messages: {} }),
}));

export const chatActions = {
    setMessages: useChatStore.getState().setMessages,
    appendMessages: useChatStore.getState().appendMessages,
    onReceiveMessage: useChatStore.getState().onReceiveMessage,
};
