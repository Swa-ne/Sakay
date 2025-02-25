import { ObjectId, startSession } from "mongoose";
import { File } from "../models/utils/file.model";
import { categoryFile, deleteFile, storage } from "../middlewares/save.config";
import { getDownloadURL, ref, uploadBytesResumable } from "firebase/storage";
import { Notification } from "../models/notification.model";

export const saveNotification = async (user_id: string, headline: string, content: string, files: Express.Multer.File[] | undefined) => {
    const session = await startSession();
    session.startTransaction();

    try {
        let saved_files: ObjectId[] = []
        if (files && files?.length > 0) {
            for (const file of files) {
                const storage_ref = ref(
                    storage,
                    `files/${file.originalname}${new Date()}`
                );
                const metadata = {
                    contentType: file.mimetype,
                };

                const snapshot = await uploadBytesResumable(
                    storage_ref,
                    file.buffer,
                    metadata
                );
                const download_url = await getDownloadURL(snapshot.ref);

                const new_file = await new File({
                    file_name: file.originalname,
                    file_type: file.mimetype,
                    file_size: file.size,
                    file_category: categoryFile(file),
                    file_url: download_url,
                }).save({ session });

                saved_files.push(new_file._id);
            }
        }
        const notification = await new Notification({
            posted_by: user_id,
            headline,
            content,
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
export const getAllNotifications = async (page: string) => {
    try {
        const notifications = await Notification.find({ is_active: true })
            .sort({ createdAt: -1 })
            .populate("files")
            .populate("posted_by")
            .populate("edited_by")
            .skip((parseInt(page) - 1) * 30)
            .limit(30);
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
export const editNotification = async (notification_id: string, user_id: string, headline: string, content: string, files: Express.Multer.File[] | undefined) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const existing_notification = await Notification.findById(notification_id);

        if (!existing_notification) {
            return { error: "Notification not found", httpCode: 404 };
        }

        if (existing_notification.files.length > 0) {
            for (const file of existing_notification.files) {
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
        let saved_files: ObjectId[] = []
        if (files && files?.length > 0) {
            for (const file of files) {
                const storage_ref = ref(
                    storage,
                    `files/${file.originalname}${new Date()}`
                );
                const metadata = {
                    contentType: file.mimetype,
                };

                const snapshot = await uploadBytesResumable(
                    storage_ref,
                    file.buffer,
                    metadata
                );
                const download_url = await getDownloadURL(snapshot.ref);

                const new_file = await new File({
                    file_name: file.originalname,
                    file_type: file.mimetype,
                    file_size: file.size,
                    file_category: categoryFile(file),
                    file_url: download_url,
                }).save({ session });

                saved_files.push(new_file._id);
            }
        }
        existing_notification.set({
            edited_by: user_id,
            headline,
            content,
            files: saved_files
        })
        await existing_notification.save({ session });

        await session.commitTransaction();
        session.endSession();
        return { message: "Success", httpCode: 200 };
    }
    catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const deleteNotification = async (notification_id: string) => {
    try {
        const notification = await Notification.findByIdAndDelete(notification_id);
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