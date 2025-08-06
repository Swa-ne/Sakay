import { AxiosError } from
    'axios'; import api from ".";
import { useAuthStore } from '@/stores/auth.store';
import { Inbox } from '@/types';
import { sendMessage } from './websocket/realtime';
const ROUTE = '/chat';

export const saveMessage = async (message: string, chat_id: string, receiver_id: string) => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.post(`${ROUTE}/save-message`, {
            message,
            chat_id
        }, {
            headers: {
                'Authorization': access_token,
            }
        });

        if (response.data.message === "Success") {
            sendMessage(receiver_id, message, chat_id)
            return true;
        }
        return false;
    } catch (error) {
        const err = error as AxiosError<{ message: string }>;
        const errMsg = err.response?.data?.message || 'Unknown error';
        return errMsg;
    }
};

export const createPrivateInbox = async (): Promise<string> => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.post(`${ROUTE}/create-private-inbox`, {}, {
            headers: {
                'Authorization': access_token,
            }
        });
        return response.data.message;
    } catch (error) {
        const err = error as AxiosError<{ error: string }>;
        const errMsg = err.response?.data?.error || 'Unknown error';
        return errMsg;
    }
};

export const openCreatedInboxContentByChatID = async (chat_id: string): Promise<string> => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.get(`${ROUTE}/open-inbox-details/${chat_id}`, {
            headers: {
                'Authorization': access_token,
            }
        });
        return response.data.message;
    } catch (error) {
        const err = error as AxiosError<{ message: string }>;
        const errMsg = err.response?.data?.message || 'Unknown error';
        return errMsg;
    }
};

export const getMessage = async (chat_id: string, cursor?: string) => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.get(`${ROUTE}/get-messages/${chat_id}`, {
            headers: {
                'Authorization': access_token,
            },
            params: { cursor }
        });
        return response.data.message;
    } catch (error) {
        const err = error as AxiosError<{ message: string }>;
        const errMsg = err.response?.data?.message || 'Unknown error';
        return errMsg;
    }
};

export const openInbox = async (): Promise<Inbox | string> => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.get(`${ROUTE}/open-inbox`, {
            headers: {
                'Authorization': access_token,
            }
        });
        return response.data.message as Inbox;
    } catch (error) {
        const err = error as AxiosError<{ message: string }>;
        const errMsg = err.response?.data?.message || 'Unknown error';
        return errMsg;
    }
};

export const getAllInboxes = async (cursor?: string) => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.get(`${ROUTE}/get-all-inbox`, {
            headers: {
                'Authorization': access_token,
            },
            params: { cursor }
        });
        return response.data.message;
    } catch (error) {
        const err = error as AxiosError<{ message: string }>;
        const errMsg = err.response?.data?.message || 'Unknown error';
        return errMsg;
    }
};

export const isReadInboxes = async (chat_id: string): Promise<boolean> => {
    try {
        const { access_token } = useAuthStore.getState();
        const response = await api.put(`${ROUTE}/is-read/${chat_id}`, {}, {
            headers: {
                'Authorization': access_token,
            }
        });
        return response.data.message === "Success";
    } catch {
        return false;
    }
};
