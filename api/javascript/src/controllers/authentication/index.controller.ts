import { Request, Response } from "express"
import { UserType } from "../../middlewares/token.authentication"
import { getCurrentUserById, getCurrentUserByUserIdentifier } from "../../services/index.services";
import { bucket, extractFilePath } from "../../middlewares/save.config";
import { getDownloadURL } from 'firebase-admin/storage';

export const getCurrentUserController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const result = await getCurrentUserById(user.user_id)
        res.status(200).json({ message: result })
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" })
    }
}
export const getFile = async (req: Request, res: Response): Promise<any> => {
    let filePath = req.query.path as string;

    if (filePath.startsWith('"') && filePath.endsWith('"')) {
        filePath = filePath.slice(1, -1);
    }

    filePath = extractFilePath(filePath)
    if (!filePath) {
        return res.status(400).send('File path is required as a query parameter.');
    }

    try {
        const file = bucket.file(filePath);

        const [exists] = await file.exists();
        if (!exists) {
            return res.status(404).send('File not found.');
        }

        const [signedUrl] = await file.getSignedUrl({
            action: 'read',
            expires: Date.now() + 60 * 60 * 1000,
        });
        res.redirect(signedUrl);
    } catch (error) {
        console.error('Error fetching file:', error);
        res.status(500).send('Internal Server Error');
    }
}