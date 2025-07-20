import { Document, model, ObjectId, Schema } from "mongoose"

export interface BusSchemaInterface extends Document {
    _id: ObjectId,
    bus_number: string,
    plate_number: string,
    milage: number,
    travel_time: number,
    createdAt?: Date,
    updatedAt?: Date,
}

const BusSchema: Schema = new Schema({
    bus_number: {
        type: String,
        default: null,
    },
    plate_number: {
        type: String,
        required: true,
    },
    milage: {
        type: Number,
        default: 0
    },
    travel_time: {
        type: Number,
        default: 0
    },
}, {
    timestamps: true,
})

export const Bus = model<BusSchemaInterface>("Bus", BusSchema)
