import { ObjectId, Schema, startSession } from "mongoose";
import { File } from "../models/utils/file.model";
import { categoryFile, deleteFile, bucket } from "../middlewares/save.config";
import { Notification } from "../models/notification.model";
import { getFileHash } from "../utils/hashing.util";

export const saveNotification = async (user_id: string, headline: string, content: string, audience: string, files: Express.Multer.File[] | undefined) => {
    const session = await startSession();
    session.startTransaction();

    try {
        let saved_files: ObjectId[] = []
        if (files && files.length > 0) {
            for (const file of files) {
                const fileHash = getFileHash(file.buffer);

                const fileName = `files/${Date.now()}-${file.originalname}`;
                const fileRef = bucket.file(fileName);

                await fileRef.save(file.buffer, {
                    metadata: { contentType: file.mimetype },
                });

                const download_url = `${process.env.DOWNLOAD_URL}${bucket.name}/${fileName}`;

                const new_file = await new File({
                    file_name: file.originalname,
                    file_type: file.mimetype,
                    file_size: file.size,
                    file_category: categoryFile(file),
                    file_url: download_url,
                    file_hash: fileHash,
                }).save({ session });

                saved_files.push(new_file._id);
            }
        }

        const notification = await new Notification({
            posted_by: user_id,
            headline,
            content,
            audience,
            files: saved_files
        }).save({ session });

        await session.commitTransaction();
        session.endSession();
        return { message: notification._id, httpCode: 200 };
    }
    catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getAllNotifications = async (page: string, user_type: string) => {
    try {
        const notifications = await Notification.find({
            $or: [
                { audience: { $exists: false } }, // Include documents where audience is not defined
                { audience: user_type === "ADMIN" ? { $exists: true } : { $in: [user_type, "EVERYONE"] } }
            ]
        })
            .sort({ createdAt: -1 })
            .populate("files")
            .populate("posted_by")
            .populate("edited_by")
            .skip((parseInt(page) - 1) * 30)
            .limit(30);
        console.log(user_type)
        return { message: notifications, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getNotification = async (notification_id: string) => {
    try {
        const notification = await Notification.findById(notification_id)
            .populate("files")
            .populate("posted_by")
            .populate("edited_by");
        return { message: notification, httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const editNotification = async (
    notification_id: string,
    user_id: string,
    headline: string,
    content: string,
    files: Express.Multer.File[] | undefined,
    existing_file_ids: string[]
) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const existing_notification = await Notification.findById(notification_id).populate('files');

        if (!existing_notification) {
            return { error: "Notification not found", httpCode: 404 };
        }

        // Get all stored files
        const storedFiles = existing_notification.files.map((file: any) => ({
            id: file._id.toString(),
            name: file.file_name,
            url: file.file_url,
            hash: file.file_hash,
        }));

        let saved_files: ObjectId[] = existing_file_ids.map(id => new Schema.Types.ObjectId(id));

        if (files && files.length > 0) {
            for (const file of files) {
                const fileHash = getFileHash(file.buffer);
                const existingFile = storedFiles.find(f => f.hash === fileHash);

                if (existingFile) {
                    saved_files.push(new Schema.Types.ObjectId(existingFile.id));
                } else {
                    const fileName = `files/${Date.now()}-${file.originalname}`;
                    const fileRef = bucket.file(fileName);

                    await fileRef.save(file.buffer, {
                        metadata: { contentType: file.mimetype },
                    });

                    const download_url = `${process.env.DOWNLOAD_URL}${bucket.name}/${fileName}`;

                    // Save new file in DB
                    const new_file = await new File({
                        file_name: file.originalname,
                        file_type: file.mimetype,
                        file_size: file.size,
                        file_category: categoryFile(file),
                        file_url: download_url,
                        file_hash: fileHash,
                    }).save({ session });

                    saved_files.push(new_file._id);
                }
            }
        }

        const newFileIds = new Set(saved_files.map(id => id.toString()));
        const filesToDelete = storedFiles.filter(file => !newFileIds.has(file.id));

        for (const file of filesToDelete) {
            await deleteFile(file.url);
            await File.findByIdAndDelete(file.id);
        }

        existing_notification.set({
            edited_by: user_id,
            headline,
            content,
            files: saved_files
        });

        await existing_notification.save({ session });

        await session.commitTransaction();
        session.endSession();
        return { message: "Success", httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
};
export const deleteNotification = async (notification_id: string) => {
    try {
        const notification = await Notification.findByIdAndDelete(notification_id);
        if (!notification) {
            return { error: "Notification not found", httpCode: 404 };
        }
        if (notification.files.length > 0) {
            for (const file of notification.files) {
                try {
                    if (typeof file === "object" && "file_url" in file) {
                        await deleteFile(file.file_url);
                        await File.findByIdAndDelete(file._id);
                    }
                } catch (err) {
                    console.error(`Error deleting file ${file}:`, err);
                }
            }
        }
        if (!notification) {
            return { error: "Notification not found", httpCode: 404 };
        }

        return { message: "Success", httpCode: 200 };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
};
export const getFilesFromNotification = async (notification_id: string) => {
    try {
        const notification = await Notification.findById(notification_id)
            .populate("files")
            .populate("posted_by")
            .populate("edited_by");
        return notification?.files;
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}