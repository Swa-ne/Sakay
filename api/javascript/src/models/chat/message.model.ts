import mongoose, { Schema, Document, ObjectId } from 'mongoose';

export interface MessageProps {
    _id: ObjectId,
    message: string,
    sender_id: ObjectId,
    chat_id: ObjectId,
    isRead: boolean
}

const MessageScheme: Schema = new Schema({
    message: {
        type: String,
        required: [true, 'Please enter Message.'],
    },
    sender_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    chat_id: {
        type: Schema.Types.ObjectId,
        ref: 'Inbox',
    },
    isRead: {
        type: Boolean,
        default: false
    },
}, {
    timestamps: true,
})

export const Message = mongoose.model<MessageProps>("Message", MessageScheme)