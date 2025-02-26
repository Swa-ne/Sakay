import { Document, model, ObjectId, Schema } from "mongoose";

export interface FileSchemaInterface extends Document {
    _id: ObjectId;
    file_name: string;
    file_type: string;
    file_size: number;
    file_category: "MEDIA" | "DOCUMENT";
    file_url: string;
    file_hash: string;
    createdAt?: Date;
    updatedAt?: Date;
}

const FileSchema: Schema = new Schema(
    {
        file_name: {
            type: String,
            required: true,
        },
        file_type: {
            type: String,
            required: true,
        },
        file_size: {
            type: Number,
            required: true,
        },
        file_category: {
            type: String,
            enum: ["MEDIA", "DOCUMENT"],
            required: true
        },
        file_url: {
            type: String,
            required: true
        },
        file_hash: {
            type: String,
            required: true
        },
    },
    {
        timestamps: true,
    }
);

export const File = model<FileSchemaInterface>("File", FileSchema);
