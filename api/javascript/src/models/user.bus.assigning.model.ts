import { Document, model, ObjectId, Schema } from "mongoose";

export interface UserBusAssigningSchemaInterface extends Document {
    _id: ObjectId,
    user_id: ObjectId,
    bus_id: ObjectId,
    is_active: boolean,
    createdAt?: Date,
    updatedAt?: Date,
}

const UserBusAssigningSchema = new Schema<UserBusAssigningSchemaInterface>({
    user_id: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    bus_id:
    {
        type: Schema.Types.ObjectId,
        ref: 'Bus',
    },
    is_active: {
        type: Boolean,
        default: true
    },
}, {
    timestamps: true,
});

export const UserBusAssigning = model<UserBusAssigningSchemaInterface>("UserBusAssigning", UserBusAssigningSchema)