import { create } from 'zustand';
import { Inbox, Message } from '@/types';
import { getUser } from '@/service/users';

interface InboxStore {
    inboxes: Inbox[];
    seenSent: Record<string, boolean>;
    setInboxes: (update: Inbox[] | ((prev: Inbox[]) => Inbox[])) => void;
    setSeen: (chat_id: string, value: boolean) => void;
    onReceiveNewMessage: (message: Message) => Promise<void>;
    reset: () => void;
}

const useInboxStore = create<InboxStore>((set, get) => ({
    inboxes: [],
    seenSent: {},

    setInboxes: (update) =>
        set((state) => ({
            inboxes: typeof update === 'function' ? update(state.inboxes) : update,
        })),

    setSeen: (chat_id, value) =>
        set((state) => ({
            seenSent: {
                ...state.seenSent,
                [chat_id]: value,
            },
        })),

    onReceiveNewMessage: async (message: Message) => {
        const { inboxes, setInboxes, setSeen } = get();

        setSeen(message.chat_id, false);

        const inboxIndex = inboxes.findIndex(
            (inbox) => inbox._id === message.chat_id
        );

        let updatedInbox: Inbox;

        if (inboxIndex !== -1) {
            const existing = inboxes[inboxIndex];
            updatedInbox = {
                ...existing,
                last_message: message,
            };
        } else {
            const user = await getUser(message.sender_id);
            updatedInbox = {
                _id: message.chat_id,
                user_id: user,
                is_active: true,
                last_message: message,
            };
        }

        const filtered = inboxes.filter((inbox) => inbox._id !== message.chat_id);
        const newInboxes = [updatedInbox, ...filtered];

        newInboxes.sort((a, b) =>
            new Date(b.last_message.createdAt).getTime() -
            new Date(a.last_message.createdAt).getTime()
        );

        setInboxes(newInboxes);
    },

    reset: () => set({ inboxes: [] }),
}));

export default useInboxStore;

export const inboxActions = {
    setInboxes: useInboxStore.getState().setInboxes,
    onReceiveNewMessage: useInboxStore.getState().onReceiveNewMessage,
};
