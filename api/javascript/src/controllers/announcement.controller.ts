import { Request, Response } from "express";
import { UserType } from "../middlewares/token.authentication";
import { validateContentLength, validateHeadlineLength } from "../utils/input.validators";
import { saveAnnouncement, deleteAnnouncement, editAnnouncement, getAllAnnouncements, getAnnouncement } from "../services/announcement.services";

export const saveAnnouncementController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        const { headline, content, audience = "EVERYONE" } = req.body;

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

        const result = await saveAnnouncement(user_id, headline, content, audience, files);
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getAllAnnouncementsController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }
        const { user_type } = user;
        if (!user_type) {
            res.status(400).json({ error: 'User Type not provided' });
            return;
        }

        const { cursor } = req.query;
        const result = await getAllAnnouncements(user_type as string, cursor as string);

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getAnnouncementController = async (req: Request, res: Response) => {
    try {
        const { announcement_id } = req.params;
        const result = await getAnnouncement(announcement_id as string);

        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const editAnnouncementController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const { announcement_id } = req.params;
        const user = req.user;
        const { headline, content, audience, existing_files } = req.body;

        if (!announcement_id) {
            res.status(404).json({ error: "Announcement not found" });
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

        const result = await editAnnouncement(announcement_id, user_id, headline, content, audience, files, JSON.parse(existing_files));
        if (result.httpCode === 200) {
            res.status(200).json({ message: result.message });
            return
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const deleteAnnouncementController = async (req: Request, res: Response) => {
    try {
        const { announcement_id } = req.params;
        if (!announcement_id) {
            res.status(404).json({ error: "Announcement not found" });
            return;
        }

        const result = await deleteAnnouncement(announcement_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
};
