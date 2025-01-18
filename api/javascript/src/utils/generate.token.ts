import jwt from 'jsonwebtoken';
import { getUserRefreshToken } from '../services/index.services';
import { User } from '../models/authentication/user.model';
import { CustomResponse } from './input.validators';

export const generateAccessTokenWithRefreshToken = async (decoded_token: jwt.JwtPayload): Promise<CustomResponse> => {
    const user = await User.findById(decoded_token.user_id)

    if (!user) return { error: "Invalid refresh token", httpCode: 401 }

    if (decoded_token.refresh_token_version !== (user.refresh_token_version)) return { error: "Refresh token is invalid", httpCode: 401 };

    return {
        message: jwt.sign(
            {
                user_id: user._id,
                email: user.personal_email,
                username: user.username,
                full_name: user.full_name
            },
            process.env.ACCESS_TOKEN_SECRET as string,
            {
                expiresIn: "30m"
            }
        ), httpCode: 200
    }
};

export const generateAccessToken = async (user_id: string): Promise<CustomResponse> => {
    const user = await User.findById(user_id)

    if (!user) return { error: "User Not Found", httpCode: 404 }

    return {
        message: jwt.sign(
            {
                user_id,
                email: user.personal_email,
                username: user.username,
                full_name: user.full_name
            },
            process.env.ACCESS_TOKEN_SECRET as string,
            {
                expiresIn: "30m"
            }
        ), httpCode: 200
    }
};

export const generateRefreshToken = async (user_id: string): Promise<string> => {
    const refresh_token_version = await getUserRefreshToken(user_id)
    return jwt.sign(
        {
            user_id,
            refresh_token_version
        },
        process.env.REFRESH_TOKEN_SECRET as string,
        {
            expiresIn: "180d"
        }
    )
};