import { Schema, Document, ObjectId, model } from 'mongoose';

export interface UserSchemaInterface extends Document {
    _id: ObjectId,
    first_name: string,
    middle_name?: string,
    last_name: string,
    profile_picture_url: string,
    email_address: string,
    phone_number: string,
    birthday: Date,
    password_hash: string,
    valid_email_address: boolean,
    valid_phone_number: boolean,
    user_type: string,
    refresh_token_version: number,
    createdAt?: Date,
    updatedAt?: Date,
}

const UserSchema: Schema = new Schema({
    first_name: {
        type: String,
        required: [true, 'Please enter your first name.'],
    },
    middle_name: {
        type: String,
    },
    last_name: {
        type: String,
        required: [true, 'Please enter your last name.'],
    },
    profile_picture_url: {
        type: String,
        default: "https://i.pinimg.com/originals/58/51/2e/58512eb4e598b5ea4e2414e3c115bef9.jpg"
    },
    email_address: {
        type: String,
        required: [true, 'Please enter your email address.'],
        unique: true,
    },
    phone_number: {
        type: String,
        unique: true,
    },
    birthday: {
        type: Date,
        required: [true, 'Please enter your birthday.'],
    },
    password_hash: {
        type: String,
        required: [true, 'Please enter your password.'],
    },
    valid_email_address: {
        type: Boolean,
        default: false
    },
    valid_phone_number: {
        type: Boolean,
        default: false
    },
    user_type: {
        type: String,
        default: "COMMUTER",
        required: [true, 'Please enter your password.'],
    },
    refresh_token_version: {
        type: Number,
        default: 0
    }
}, {
    timestamps: true,
});

export const User = model<UserSchemaInterface>("User", UserSchema)