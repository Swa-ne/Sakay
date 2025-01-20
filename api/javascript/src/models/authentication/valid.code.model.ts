import { Document, model, ObjectId, Schema } from "mongoose"

export interface UserValidCodeSchemaInterface extends Document {
    user_id: ObjectId,
    code: string,
    expiresAt: Date
}

const UserValidCodeSchema: Schema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        default: null,
    },
    code: {
        type: String,
        required: true,
    },
    expiresAt: {
        type: Date,
        required: true,
    },
})

export const UserValidCode = model<UserValidCodeSchemaInterface>("UserValidCode", UserValidCodeSchema)
