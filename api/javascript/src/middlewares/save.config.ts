import multer, { FileFilterCallback } from 'multer';
import admin, { ServiceAccount } from 'firebase-admin';

import config from '../config/firebase.config';
import { Request } from 'express';

admin.initializeApp({
    credential: admin.credential.cert(config.firebaseConfig as ServiceAccount),
    storageBucket: process.env.STORAGE_BUCKET,
});

export const bucket = admin.storage().bucket();

const fileFilter = (req: Request, file: Express.Multer.File, cb: FileFilterCallback) => {
    if (file.mimetype.startsWith("image/") || file.mimetype.startsWith("video/")) {
        req.body.fileCategory = "media";
        cb(null, true);
    } else {
        req.body.fileCategory = "document";
        cb(null, true);
    }
};
export const categoryFile = (file: Express.Multer.File) => {
    return file.mimetype.startsWith("image/") || file.mimetype.startsWith("video/") ? "MEDIA" : "DOCUMENT";
};

export const deleteFile = async (filePath: string) => {
    try {
        const url = extractFilePathMedia(filePath);
        if (!url) {
            throw new Error("File not found!");
        }

        const file = bucket.file(url);
        await file.delete();
    } catch (error) {
        throw error;
    }
};

function extractFilePathMedia(url: string): string | null {
    const regex = /\/o\/(.*?)\?alt=media/;
    const match = url.match(regex);

    return match && match[1] ? decodeURIComponent(match[1]) : null;
}

export function extractFilePath(url: string): string {
    const regex = /https:\/\/storage\.googleapis\.com\/[^/]+\/(.+)/;
    const match = url.match(regex);

    return match ? match[1] : "";
}

export const uploadFiles = multer({ storage: multer.memoryStorage(), fileFilter });

