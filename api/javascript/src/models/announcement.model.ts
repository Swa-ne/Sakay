import { Document, model, ObjectId, Schema } from "mongoose"
import { FileSchemaInterface } from "./utils/file.model"

export interface AnnouncementSchemaInterface extends Document {
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

const AnnouncementSchema: Schema = new Schema({
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

export const Announcement = model<AnnouncementSchemaInterface>("Announcement", AnnouncementSchema)
