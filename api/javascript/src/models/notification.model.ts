import { Document, model, ObjectId, Schema } from "mongoose"
import { FileSchemaInterface } from "./utils/file.model"

export interface NotificationSchemaInterface extends Document {
    _id: ObjectId,
    posted_by: ObjectId,
    edited_by?: ObjectId,
    headline: string,
    content: string,
    audience: "EVERYONE" | "DRIVER" | "COMMUTER",
    files: ObjectId[] | FileSchemaInterface[],
    createdAt?: Date,
    updatedAt?: Date,
}

const NotificationSchema: Schema = new Schema({
    posted_by: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    edited_by: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    headline: {
        type: String,
        default: null,
    },
    content: {
        type: String,
        required: true,
    },
    audience: {
        type: String,
        enum: ["EVERYONE", "DRIVER", "COMMUTER"],
        required: true
    },
    files: [
        {
            type: Schema.Types.ObjectId,
            ref: "File",
        },
    ],
}, {
    timestamps: true,
})

export const Notification = model<NotificationSchemaInterface>("Notification", NotificationSchema)
