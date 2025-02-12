import { Request, Response } from 'express';
import { checkEmailAvailability, checkEmailVerified, checkPhoneNumberAvailability, signupUsertoDatabase } from '../../services/authentication/signup.services';
import { UserSchemaInterface } from '../../models/authentication/user.model';
import { checkEveryInputForSignup, checkPhoneNumberValidity } from '../../utils/input.validators';
import { generateAccessAndRefereshTokens, sendEmailCode, verifyEmailCode } from '../../services/index.services';
import { UserType } from '../../middlewares/token.authentication';

interface CustomRequestBody extends UserSchemaInterface {
    confirmation_password: string
}

export const checkEmailVerifiedController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id } = user;
        const result = await checkEmailVerified(user_id);
        if (result) {
            res.status(200).json({ message: "Success" });
            return;
        }
        res.status(403).json({ message: "Email is not yet verified" });
    } catch (e) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const checkEmailAvailabilityController = async (req: Request, res: Response) => {
    try {
        let email_address: string = req.body.email_address;
        if (!email_address) {
            res.status(404).json({ error: "Email address not found" });
            return;
        }
        email_address = email_address.toLowerCase();
        if (!(await checkEmailAvailability(email_address))) {
            res.status(409).json({ error: 'This email address is being used.' });
            return;
        }
        res.status(200).json({ message: "Success" });
    } catch (e) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const checkPhoneNumberValidityController = async (req: Request, res: Response) => {
    try {
        let phone_number: string = req.body.phone_number;
        if (!phone_number) {
            res.status(404).json({ error: "Phone number not found" });
            return;
        }
        if (!checkPhoneNumberValidity(phone_number)) {
            res.status(400).json({ error: 'Please enter a valid phone number' });
            return;
        }
        if (!(await checkPhoneNumberAvailability(phone_number))) {
            res.status(409).json({ error: 'This phone number is being used.' });
            return;
        }
        res.status(200).json({ message: "Success" });
    } catch (e) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const signupUserController = async (req: Request, res: Response) => {
    try {
        const { first_name, last_name, phone_number, password_hash, confirmation_password, birthday, user_type }: CustomRequestBody = req.body;
        let email_address: string = req.body.email_address;
        if (!email_address && !phone_number) {
            res.status(404).json({ error: "Email address or phone number not found" });
            return
        }
        email_address = email_address.toLowerCase()
        const requiredFields = {
            first_name,
            last_name,
            password_hash,
            confirmation_password,
            birthday,
            user_type,
        };

        const updatedKey: { [key: string]: string } = {
            first_name: "First Name",
            last_name: "Last Name",
            username: "Username",
            password_hash: "Password",
            confirmation_password: "Confirmation Password",
            birthday: "Birthday",
            user_type: "User Type",
        }
        for (const [key, value] of Object.entries(requiredFields)) {
            if (!value) {
                res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
                return;
            }
        }

        const checkerForInput = await checkEveryInputForSignup(phone_number, email_address, password_hash, confirmation_password);
        if (checkerForInput.message === 'Success') {
            const data = await signupUsertoDatabase(first_name, last_name, email_address, phone_number, password_hash, birthday, user_type);
            if (data.httpCode !== 200) {
                res.status(500).json({ error: data.error });
                return;
            }
            res
                .status(200)
                .cookie(
                    "refresh_token",
                    data.refresh_token,
                    {
                        httpOnly: true,
                        secure: true,
                        sameSite: 'none',
                    }
                )
                .json({ message: "Success", access_token: data.access_token, user_id: data.user_id, user_type: data.user_type });
            return;
        }

        res.status(checkerForInput.httpCode).json({ error: checkerForInput.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
};

export const resendEmailCodeController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id, email, full_name } = user;
        await sendEmailCode(user_id, email, full_name);
        res.status(200).json({ message: "Success" });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}

export const verifyEmailCodeController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const { user_id, user_type } = user;
        const { code } = req.body;
        const result = await verifyEmailCode(user_id, code);
        if (result.httpCode === 200) {
            const result_token = await generateAccessAndRefereshTokens(user_id);
            res
                .status(200)
                .cookie(
                    "refresh_token",
                    result_token.message?.refresh_token,
                    {
                        httpOnly: true,
                        secure: true,
                        sameSite: 'none',
                    }
                )
                .json({ message: "Success", access_token: result_token.message?.access_token, user_id, user_type });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: "Internal Server Error" });
    }
}