import * as bcrypt from "bcrypt";
import { User, UserSchemaInterface } from "../../models/authentication/user.model";
import { CustomResponse } from "../../utils/input.validators";
import { generateAccessAndRefereshTokens, sendEmailCode } from "../index.services";

export const signupUsertoDatabase = async (
    first_name: string,
    middle_name: string | undefined,
    last_name: string,
    username: string,
    bio: string | undefined,
    personal_email: string,
    birthday: Date,
    password: string,
    valid_email: boolean,
): Promise<CustomResponse> => {
    let userCredentialResult;

    try {
        const saltRounds = await bcrypt.genSalt();
        const password_hash = await bcrypt.hash(password, saltRounds);
        userCredentialResult = await new User({
            first_name,
            middle_name,
            last_name,
            username,
            bio,
            full_name: `${first_name} ${middle_name ? ` ${middle_name}` : ''} ${last_name}`.trim(),
            personal_email,
            birthday,
            password_hash,
            valid_email
        }).save();
        // await new ActiveUsers({
        //     userId: userCredentialResult._id,
        //     active: "0",
        //     fullName: userCredentialResult.full_name
        // }).save();

        await sendEmailCode(`${userCredentialResult._id}`, personal_email, first_name)

        const result: any = await generateAccessAndRefereshTokens(userCredentialResult._id.toString());
        if (result.httpCode === 200) {
            return {
                message: "Congratulations, your account has been successfully created",
                access_token: result.message?.access_token,
                refresh_token: result.message?.refresh_token,
                user_id: userCredentialResult._id,
                httpCode: 200
            };
        }
        return { error: result.error, httpCode: result.httpCode }
    } catch (error) {
        if (userCredentialResult) {
            await userCredentialResult.deleteOne();
        }
        return { error: "Internal Server Error", httpCode: 500 };
    }
};

export const checkUsernameAvailability = async (username: string): Promise<boolean> => {
    try {
        const result = (await User.findOne({ username: { $regex: new RegExp(`^${username}$`, 'i') } })) === null;
        return result;
    } catch (error) {
        return false;
    }
};

export const checkEmailAvailability = async (emailAddress: string): Promise<boolean> => {
    try {
        const result: boolean = (await User.findOne({ personal_email: { $regex: new RegExp(`^${emailAddress}$`, 'i') } })) === null;
        return result;
    } catch (error) {
        return false;
    }
};

export const checkEmailVerified = async (user_id: string): Promise<boolean> => {
    try {
        const result = await User.findById(user_id);
        if (!result) {
            return false;
        }

        return result.valid_email;
    } catch (error) {
        return false;
    }
};

export const getDataByEmailAddress = async (emailAddress: string): Promise<UserSchemaInterface | null> => {
    try {
        const result: UserSchemaInterface | null = await User.findOne({ personal_email: { $regex: new RegExp(`^${emailAddress}$`, 'i') } });
        return result;
    } catch (error) {
        return null;
    }
};
