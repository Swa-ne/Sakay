import { Request, Response } from "express";
import { UserType } from "../middlewares/token.authentication";
import { validateContentLength, validateHeadlineLength } from "../utils/input.validators";
import { saveNotification, deleteNotification, editNotification, getAllNotifications, getNotification } from "../services/notification.services";

export const saveNotificationController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        const { headline, content } = req.body;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        if (!user_id) {
            res.status(400).json({ error: 'User ID not provided' });
            return;
        }

        if (!validateHeadlineLength(headline)) {
            res.status(413)
                .json({
                    error: "The headline must contain between 1 and 15 words.",
                });
            return;
        }

        if (!validateContentLength(content)) {
            res.status(413)
                .json({
                    error: "The content must contain between 2 and 250 words.",
                });
            return;
        }

        const files = req.files as Express.Multer.File[];

        const result = await saveNotification(user_id, headline, content, files);
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getAllNotificationsController = async (req: Request, res: Response) => {
    try {
        const { page = 1 } = req.params;
        const result = await getAllNotifications(page as string);

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getNotificationController = async (req: Request, res: Response) => {
    try {
        const { notif_id } = req.params;
        const result = await getNotification(notif_id as string);

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const editNotificationController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const { notif_id } = req.params;
        const user = req.user;
        const { headline, content, existing_files } = req.body;

        if (!notif_id) {
            res.status(404).json({ error: "Notification not found" });
            return;
        }
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        if (!user_id) {
            res.status(400).json({ error: 'User ID not provided' });
            return;
        }

        if (!validateHeadlineLength(headline)) {
            res.status(413)
                .json({
                    error: "The headline must contain between 1 and 15 words.",
                });
            return;
        }

        if (!validateContentLength(content)) {
            res.status(413)
                .json({
                    error: "The headline must contain between 2 and 250 words.",
                });
            return;
        }

        const files = req.files as Express.Multer.File[];

        const result = await editNotification(notif_id, user_id, headline, content, files, JSON.parse(existing_files));
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const deleteNotificationController = async (req: Request, res: Response) => {
    try {
        const { notif_id } = req.params;
        if (!notif_id) {
            res.status(404).json({ error: "Notification not found" });
            return;
        }

        const result = await deleteNotification(notif_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
};
