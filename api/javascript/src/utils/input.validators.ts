import { ObjectId } from "mongoose";
import { checkEmailAvailability, checkPhoneNumberAvailability } from "../services/authentication/signup.services";


export interface CustomResponse {
    user_id?: ObjectId,
    message?: string | any[];
    error?: string,
    user_type?: string,
    access_token?: string,
    refresh_token?: string,
    httpCode: number
}
const USER_IDENTIFIER_CONST = { "email_address": "EMAIL_ADDRESS", "phone_number": "PHONE_NUMBER" };

export const checkEveryInputForSignup = async (phone_number: string, email_address: string, password: string, confirmationPassword: string): Promise<CustomResponse> => {
    if (!checkPhoneNumberValidity(phone_number) && phone_number !== "") {
        return { error: 'Please enter a valid phone number', "httpCode": 400 };
    }
    if (!checkEmailValidity(email_address)) {
        return { error: 'Please enter a valid email address', "httpCode": 400 };
    }
    if (!checkPasswordValidity(password)) {
        return { error: 'Password must have at least one lowercase letter, one uppercase letter, one numeric digit, and one special character.', "httpCode": 400 };
    }
    if (!(await checkPhoneNumberAvailability(phone_number))) {
        return { error: 'This phone number is being used.', "httpCode": 409 };
    }
    if (!(await checkEmailAvailability(email_address))) {
        return { error: 'This email address is being used.', "httpCode": 409 };
    }
    if (password !== confirmationPassword) {
        return { error: "Those password didn't match. Try again.", "httpCode": 400 };
    }
    return { message: 'Success', "httpCode": 200 };
};

export const checkEveryInputForLogin = async (user_identifier: string, password: string, user_identifier_type: string) => {

    if (user_identifier_type === USER_IDENTIFIER_CONST.phone_number) {
        if (!checkPhoneNumberValidity(user_identifier)) {
            return { 'error': 'Please enter a valid email phone_number', "httpCode": 400 };
        }
    } else {
        if (!checkEmailValidity(user_identifier)) {
            return { 'error': 'Please enter a valid email address', "httpCode": 400 };
        }
    }
    if (!checkPasswordValidity(password)) {
        return { 'error': 'Sorry, looks like that\'s the wrong email or password.', "httpCode": 401 };
    }
    return { 'message': 'success', "httpCode": 200 };
};

export const checkPhoneNumberValidity = (phone_number: string) => {
    // TODO: max 25 characters
    const regex = /^(09|\+639)\d{9}$/;
    return regex.test(phone_number);
};

export const checkEmailValidity = (email_address: string) => {
    // Validates an email address format (e.g., example@domain.com)
    const regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/;
    return regex.test(email_address);
};

export const checkPasswordValidity = (password: string) => {
    // least one lowercase letter, one uppercase letter, one numeric digit, and one special character
    const regex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s)./;
    return regex.test(password);
};

export const validateRequiredFields = (fields: Record<string, any>, fieldLabels: Record<string, string>) => {
    for (const [key, value] of Object.entries(fields)) {
        if (value == null) {
            return { valid: false, error: `${fieldLabels[key]} is required and cannot be null or undefined.` };
        }
    }
    return { valid: true };
};

export const validateDescriptionLength = (description: string) => {
    const wordCount = description.trim().split(/\s+/).length;
    return wordCount <= 250;
};

export const validateReviewCommentLength = (description: string) => {
    const wordCount = description.trim().split(/\s+/).length;
    return wordCount <= 250;
};

export const checkInputType = async (user_identifier: string) => {
    return user_identifier.includes('@') ? USER_IDENTIFIER_CONST.email_address : USER_IDENTIFIER_CONST.phone_number;
};