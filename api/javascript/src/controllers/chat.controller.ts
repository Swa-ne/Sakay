import { Request, Response } from "express";
import { createInbox, getChatMessages, openInboxByUserID, openCreatedInboxContentByChatID, saveMessage, getAllInboxes, getLastMessageFromInbox, isReadChat } from "../services/chat.services";
import { UserType } from "../middlewares/token.authentication";

export const getAllInboxesController = async (req: Request, res: Response) => {
    try {
        const { cursor } = req.query;
        const result = await getAllInboxes(cursor as string);

        if (result.httpCode === 200) {
            if (result.message && result.message.inbox.length !== 0) {
                const inboxes = await Promise.all(
                    result.message.inbox.map(async (inbox) => {
                        const last_message = await getLastMessageFromInbox(inbox._id);
                        return {
                            ...inbox._doc,
                            last_message: last_message.message
                        };
                    })
                );

                inboxes.sort((a, b) =>
                    new Date(b.last_message.createdAt).getTime() -
                    new Date(a.last_message.createdAt).getTime()
                );

                res.status(200).json({ message: { inboxes, nextCrusor: result.message.nextCursor } });
                return;
            }
            res.status(200).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const createPrivateInboxController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        if (!user_id) {
            res.status(400).json({ error: 'User ID not provided' });
            return;
        }
        const result = await createInbox(user_id);
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const openCreatedInboxContentByChatIDController = async (req: Request, res: Response) => {
    try {
        const { chat_id } = req.params;
        if (!chat_id) {
            res.status(400).json({ message: 'Chat ID not provided' });
            return;
        }

        const result = await openCreatedInboxContentByChatID(chat_id as string)
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ 'message': 'Internal Server Error' });
    }
};

export const saveMessageController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        const { message, chat_id } = req.body;
        if (!user_id) {
            res.status(400).json({ message: 'User ID not provided' });
            return;
        }
        if (!chat_id) {
            res.status(400).json({ message: 'Chat ID not provided' });
            return;
        }
        const result = await saveMessage(message, user_id, chat_id)

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const getMessagesController = async (req: Request, res: Response) => {
    try {
        const { chat_id } = req.params;
        const { cursor } = req.query;
        if (!chat_id) {
            res.status(400).json({ message: 'Chat ID not provided' });
            return;
        }
        const result = await getChatMessages(chat_id as string, cursor as string)

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const openInboxByUserIDController = async (req: Request & { user?: UserType }, res: Response): Promise<any> => {
    try {
        const user = req.user;
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        if (!user_id) {
            res.status(400).json({ message: 'User ID not provided' });
            return;
        }

        const result = await openInboxByUserID(user_id)
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ 'message': 'Internal Server Error' });
    }
};
export const isReadChatController = async (req: Request & { user?: UserType }, res: Response): Promise<any> => {
    try {
        const user = req.user;
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }
        const { user_id } = user;
        if (!user_id) {
            res.status(400).json({ message: 'User ID not provided' });
            return;
        }

        const { chat_id } = req.params;
        if (!chat_id) {
            res.status(400).json({ message: 'Chat ID not provided' });
            return;
        }

        const result = await isReadChat(user_id, chat_id)
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ 'message': 'Internal Server Error' });
    }
};