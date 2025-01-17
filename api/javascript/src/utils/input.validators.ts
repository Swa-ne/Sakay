import { ObjectId } from "mongoose";
import { checkEmailAvailability, checkUsernameAvailability } from "../services/authentication/signup.services";


export interface CustomResponse {
    user_id?: ObjectId,
    message?: string | any[];
    error?: string,
    access_token?: string,
    refresh_token?: string,
    httpCode: number
}

export const checkEveryInputForSignup = async (username: string, emailAddress: string, password: string, confirmationPassword: string): Promise<CustomResponse> => {
    if (!checkUsernameValidity(username)) {
        return { error: 'Please enter a valid username', "httpCode": 400 };
    }
    if (!checkEmailValidity(emailAddress)) {
        return { error: 'Please enter a valid email address', "httpCode": 400 };
    }
    if (!checkPasswordValidity(password)) {
        return { error: 'Password must have at least one lowercase letter, one uppercase letter, one numeric digit, and one special character.', "httpCode": 400 };
    }
    if (!(await checkEmailAvailability(emailAddress))) {
        return { error: 'This email address is being used.', "httpCode": 409 };
    }
    if (!(await checkUsernameAvailability(username))) {
        return { error: 'This username is being used.', "httpCode": 409 };
    }
    if (password !== confirmationPassword) {
        return { error: "Those password didn't match. Try again.", "httpCode": 400 };
    }
    return { message: 'Success', "httpCode": 200 };
};

export const checkEveryInputForLogin = async (userIdentifier: string, password: string) => {
    if (!checkEmailValidity(userIdentifier)) {
        return { 'error': 'Please enter a valid email address', "httpCode": 400 };
    }
    if (!checkPasswordValidity(password)) {
        return { 'error': 'Sorry, looks like that\'s the wrong email or password.', "httpCode": 401 };
    }
    return { 'message': 'success', "httpCode": 200 };
};

export const checkUsernameValidity = (username: string) => {
    // TODO: max 25 characters
    const regex = /^[a-zA-Z0-9]+$/;
    return regex.test(username);
};

export const checkEmailValidity = (emailAddress: string) => {
    // Validates an email address format (e.g., example@domain.com)
    const regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/;
    return regex.test(emailAddress);
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

export const validateBioLength = (input: string | undefined,) => {
    if (!input) {
        return true
    }
    const words = input.trim().split(/\s+/);
    return words.length > 80
}