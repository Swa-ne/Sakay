import { User, UserSchemaInterface } from "../../models/authentication/user.model";
import * as bcrypt from "bcrypt";
import { CustomResponse } from "../../utils/input.validators";

export const loginUsertoDatabase = async (user_identifier: string, password: string) => {
    try {
        let result = await User.findOne({ personal_email: { $regex: new RegExp(`^${user_identifier}$`, 'i') } });
        if (result) {
            if (await bcrypt.compare(password, result.password_hash)) {
                return { 'message': 'Success', "httpCode": 200 };
            }
            return { 'error': 'Sorry, looks like that\'s the wrong email or password.', "httpCode": 401 };
        }
        return { 'error': 'It looks like you haven\'t signed up yet. Please create an account to log in.', "httpCode": 404 };
    } catch {
        return { 'error': 'Internal Server Error.', "httpCode": 500 };
    }
};

export const getDataByEmailAddress = async (email_address: string): Promise<UserSchemaInterface | null> => {
    try {
        const result: UserSchemaInterface | null = await User.findOne({ personal_email: { $regex: new RegExp(`^${email_address}$`, 'i') } });
        return result;
    } catch (error) {
        return null;
    }
};

export const changePassword = async (user_id: string, new_password: string): Promise<CustomResponse> => {
    try {
        const user = await User.findById(user_id)
        if (!user) {
            return { error: "User not found", httpCode: 404 };
        }

        const saltRounds = await bcrypt.genSalt();
        const password_hash = await bcrypt.hash(new_password, saltRounds);

        user.password_hash = password_hash
        await user.save()

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const isOldPasswordSimilar = async (user_id: string, old_password: string): Promise<CustomResponse> => {
    try {
        const user = await User.findById(user_id)
        if (!user) {
            return { error: "User not found", httpCode: 404 };
        }
        if (!(await bcrypt.compare(old_password, user.password_hash))) return { error: "Current password is incorrect. Please try again.", httpCode: 401 }

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
}

export const editProfile = async (
    user_id: string,
    first_name: string,
    middle_name: string | undefined,
    last_name: string,
    username: string,
    bio: string | undefined,
    // personal_number: string | undefined,
    birthday: Date,
    profile_picture_url: string | undefined
): Promise<CustomResponse> => {
    try {
        await User.findOneAndUpdate(
            { _id: user_id },
            {
                $set: {
                    first_name,
                    middle_name,
                    last_name,
                    username,
                    bio,
                    // personal_number,
                    birthday,
                    profile_picture_url
                }
            }
        );

        return { message: "Success", httpCode: 200 }
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 }
    }
};