import mongoose, { Schema, Document, ObjectId } from 'mongoose';


export interface InboxSchemeInterface extends Document {
    _id: string,
    user_id: ObjectId,
    was_active: boolean,
    _doc: any,
}

const InboxScheme: Schema = new Schema({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    was_active: {
        type: Boolean,
        default: false
    },
}, {
    timestamps: true,
})

export const Inbox = mongoose.model<InboxSchemeInterface>("Inbox", InboxScheme)