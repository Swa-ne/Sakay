import mongoose, { Schema, Document, ObjectId } from 'mongoose';


export interface InboxSchemeInterface extends Document {
    _id: string,
    user_id: ObjectId,
    is_active: boolean,
    createdAt?: Date,
    updatedAt?: Date,
    _doc: any,
}

const InboxScheme: Schema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    is_active: {
        type: Boolean,
        default: false
    },
}, {
    timestamps: true,
})

export const Inbox = mongoose.model<InboxSchemeInterface>("Inbox", InboxScheme)