import { Document, model, ObjectId, Schema } from "mongoose";

export interface SavedSchemaInterface extends Document {
    _id: ObjectId,
    user_id: ObjectId,
    bus_id: ObjectId,
    createdAt?: Date,
    updatedAt?: Date,
}

const UserBusAssigningSchema = new Schema<SavedSchemaInterface>({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    bus_id:
    {
        type: Schema.Types.ObjectId,
        ref: 'Bus',
    },
}, {
    timestamps: true,
});

export const UserBusAssigning = model<SavedSchemaInterface>("UserBusAssigning", UserBusAssigningSchema)