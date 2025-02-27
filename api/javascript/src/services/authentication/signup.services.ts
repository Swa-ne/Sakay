import * as bcrypt from "bcryptjs";
import { User, UserSchemaInterface } from "../../models/authentication/user.model";
import { CustomResponse } from "../../utils/input.validators";
import { generateAccessAndRefereshTokens, sendEmailCode } from "../index.services";

export const signupUsertoDatabase = async (
    first_name: string,
    last_name: string,
    email_address: string,
    phone_number: string,
    password: string,
    birthday: Date,
    user_type: string,
): Promise<CustomResponse> => {
    let userCredentialResult;

    try {
        const saltRounds = await bcrypt.genSalt();
        const password_hash = await bcrypt.hash(password, saltRounds);
        userCredentialResult = await new User({
            first_name,
            last_name,
            email_address,
            phone_number,
            password_hash,
            birthday,
            user_type,
        }).save();

        await sendEmailCode(`${userCredentialResult._id}`, email_address, first_name)

        const result: any = await generateAccessAndRefereshTokens(userCredentialResult._id.toString());
        if (result.httpCode === 200) {
            return {
                message: "Congratulations, your account has been successfully created",
                access_token: result.message?.access_token,
                refresh_token: result.message?.refresh_token,
                user_id: userCredentialResult._id,
                user_type: userCredentialResult.user_type,
                first_name: userCredentialResult.first_name,
                last_name: userCredentialResult.last_name,
                email: userCredentialResult.email_address,
                profile: userCredentialResult.profile_picture_url,
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

export const checkEmailAvailability = async (email_address: string): Promise<boolean> => {
    try {
        const result: boolean = (await User.findOne({ email_address: { $regex: new RegExp(`^${email_address}$`, 'i') } })) === null;
        return result;
    } catch (error) {
        return false;
    }
};
export const checkPhoneNumberAvailability = async (phone_number: string): Promise<boolean> => {
    try {
        const result: boolean = (await User.findOne({ phone_number: { $regex: new RegExp(`^${phone_number}$`, 'i') } })) === null;
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

        return result.valid_email_address;
    } catch (error) {
        return false;
    }
};

export const getDataByEmailAddress = async (emailAddress: string): Promise<UserSchemaInterface | null> => {
    try {
        const result: UserSchemaInterface | null = await User.findOne({ email_address: { $regex: new RegExp(`^${emailAddress}$`, 'i') } });
        return result;
    } catch (error) {
        return null;
    }
};
