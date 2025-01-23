import { Request, Response } from 'express';
import jwt, { TokenExpiredError } from 'jsonwebtoken';

import { checkEveryInputForLogin, checkInputType, checkPhoneNumberValidity } from '../../utils/input.validators';
import { changePassword, editProfile, getDataByUserIdentifier, isOldPasswordSimilar, loginUsertoDatabase } from '../../services/authentication/login.services';
import { generateAccessAndRefereshTokens, getCurrentUserById, getCurrentUserByUserIdentifier, sendEmailForgetPassword } from '../../services/index.services';
import { UserType } from '../../middlewares/token.authentication';
import { checkPhoneNumberAvailability } from '../../services/authentication/signup.services';


export const loginUserController = async (req: Request, res: Response) => {
    try {
        const { user_identifier, password } = req.body;
        const user_identifier_type = await checkInputType(user_identifier);
        const checker_for_input = await checkEveryInputForLogin(user_identifier, password, user_identifier_type);

        if (checker_for_input.httpCode === 200) {
            const data = await loginUsertoDatabase(user_identifier, password);

            if (data.httpCode === 200) {
                const user_data = await getDataByUserIdentifier(user_identifier);

                if (!user_data) {
                    res.status(404).json({ error: "User not found" });
                    return;
                }

                const result = await generateAccessAndRefereshTokens(user_data._id.toString());
                if (result.httpCode !== 200) {
                    res.status(result.httpCode).json({ error: result.error })
                    return;
                }

                res
                    .status(200)
                    .cookie(
                        "refresh_token",
                        result.message?.refresh_token,
                        {
                            httpOnly: true,
                            secure: true,
                            sameSite: 'none',
                        }
                    )
                    .json({ message: "Success", access_token: result.message?.access_token, user_id: user_data._id, user_type: user_data.user_type });
                return;
            }
            res.status(data.httpCode).json({ error: data.error });
            return;
        }
        res.status(checker_for_input.httpCode).json({ error: checker_for_input.error });
    } catch (error) {
        res.status(500).json({ 'error': 'Internal Server Error' });
    }
};

export const changePasswordController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { old_password, new_password, confirmation_password } = req.body;

        if (new_password !== confirmation_password) {
            res.status(400).json({ error: "New password does not match. Enter new password again here." });
            return;
        }

        const is_old_password_similar = await isOldPasswordSimilar(user.user_id, old_password);
        if (is_old_password_similar.httpCode === 200) {
            await changePassword(user.user_id, new_password)
            res.status(is_old_password_similar.httpCode).json({ message: is_old_password_similar.message })
            return;
        }
        res.status(is_old_password_similar.httpCode).json({ error: is_old_password_similar.error })
    } catch (error) {
        res.status(500).json({ 'error': 'Internal Server Error' });
    }
}
export const editProfileController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { first_name, last_name, phone_number, birthday, profile_picture_url } = req.body;

        const requiredFields = {
            first_name,
            last_name,
            birthday
        };

        const updatedKey: { [key: string]: string } = {
            first_name: "First Name",
            last_name: "Last Name",
            birthday: "Birthday",
        }
        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
                return;
            }
        }

        if (!checkPhoneNumberValidity(phone_number)) {
            res.status(400).json({ error: 'Please enter a valid phone number' });
            return;
        }
        if (!(await checkPhoneNumberAvailability(phone_number))) {
            res.status(409).json({ error: 'This phone number is being used.' });
            return;
        }

        const data = await editProfile(user.user_id, first_name, last_name, phone_number, birthday, profile_picture_url);
        if (data.httpCode !== 200) {
            res.status(500).json({ error: data.error });
            return;
        }
        res.status(200).json({ message: data.message });
    } catch (error) {
        res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const forgotPasswordController = async (req: Request, res: Response) => {
    try {
        const { email_address, phone_number } = req.body;
        let user;
        const user_identifier = (email_address !== null) ? email_address : phone_number;
        user = await getCurrentUserByUserIdentifier(user_identifier);
        if (!user) {
            res.status(404).json({ error: "User not found" })
            return;
        }

        const token = jwt.sign({ email: user.email_address, user_id: user._id }, process.env.ACCESS_TOKEN_SECRET as string, {
            expiresIn: "120m",
        });
        await sendEmailForgetPassword(user._id.toString(), email_address, `${user.first_name} ${user.last_name}`)
        res.status(200).json({ message: "Success", token });
    } catch (error) {
        res.status(500).json({ 'error': 'Internal Server Error' });
    }
}

export const postResetPasswordController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }
        const { user_id } = user;
        const { password, confirmation_password } = req.body;

        if (password !== confirmation_password) {
            res.status(400).json({ error: "Those password didn't match. Try again." });
            return;
        }

        const result = await getCurrentUserById(user_id);
        if (!result) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { httpCode, message, error } = await changePassword(user_id, password);

        if (httpCode === 200) {
            res.status(httpCode).json({ message })
            return;
        }
        res.status(httpCode).json({ error })
    } catch (error) {
        if (error instanceof TokenExpiredError) {
            res.status(401).json({ error: "Token has expired" });
            return;
        }
        res.status(500).json({ error: "Internal Server Error" });
    }
}
