import { Document, model, ObjectId, Schema } from "mongoose"

export interface ReportSchemaInterface extends Document {
    _id: ObjectId,
    bus: ObjectId,
    reporter: ObjectId,
    investigator?: ObjectId,
    driver?: ObjectId,
    type_of_report: "PERFORMANCE" | "INCIDENT" | "MAINTENANCE",
    description: string,
    place_of_incident?: string,
    time_of_incident?: string,
    date_of_incident?: string,
    driving_rate?: number,
    service_rate?: number,
    reliability_rate?: number,
    is_open: boolean,
    createdAt?: Date,
    updatedAt?: Date,
}

const ReportSchema: Schema = new Schema({
    bus: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'Bus',
    },
    reporter: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'User',
    },
    investigator: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    driver: {
        type: Schema.Types.ObjectId,
        ref: 'User',
    },
    type_of_report: {
        type: String,
        enum: ["PERFORMANCE", "INCIDENT", "MAINTENANCE"],
        required: true
    },
    description: {
        type: String,
        required: true
    },
    place_of_incident: {
        type: String,
    },
    time_of_incident: {
        type: String,
    },
    date_of_incident: {
        type: String,
    },
    driving_rate: {
        type: Number,
    },
    service_rate: {
        type: Number,
    },
    reliability_rate: {
        type: Number,
    },
    is_open: {
        type: Boolean,
        default: true
    },
}, {
    timestamps: true,
})

export const Report = model<ReportSchemaInterface>("Report", ReportSchema)
