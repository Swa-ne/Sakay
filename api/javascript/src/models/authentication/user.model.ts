import { Schema, Document, ObjectId, model } from 'mongoose';

export interface UserSchemaInterface extends Document {
    _id: ObjectId,
    first_name: string,
    middle_name?: string,
    last_name: string,
    username: string,
    full_name: string,
    bio?: string,
    profile_picture_url: string,
    personal_email: string,
    birthday: Date,
    password_hash: string,
    valid_email: boolean,
    is_admin: boolean,
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
    username: {
        type: String,
        required: [true, 'Please enter your username.'],
    },
    full_name: {
        type: String,
        required: [true, 'Please enter your full name.'],
    },
    bio: {
        type: String,
    },
    profile_picture_url: {
        type: String,
        default: "https://i.pinimg.com/originals/58/51/2e/58512eb4e598b5ea4e2414e3c115bef9.jpg"
    },
    personal_email: {
        type: String,
        required: [true, 'Please enter your personal Email.'],
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
    valid_email: {
        type: Boolean,
        default: false
    },
    is_admin: {
        type: Boolean,
        default: false
    },
    refresh_token_version: {
        type: Number,
        default: 0
    }
}, {
    timestamps: true,
});

export const User = model<UserSchemaInterface>("User", UserSchema)