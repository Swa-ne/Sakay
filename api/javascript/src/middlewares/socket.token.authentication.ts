import jwt, { TokenExpiredError, JwtPayload } from 'jsonwebtoken';
import { generateAccessTokenWithRefreshToken } from '../utils/generate.token';
import { UserType } from './token.authentication';

export async function socketAuthenticate(socket: any, next: (err?: Error) => void) {
    try {
        const token = socket.handshake.auth?.token;
        if (!token) {
            return next(new Error('Unauthorized: No token provided'));
        }

        const user = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET as string) as UserType;
        socket.user = user;
        return next();
    } catch (err) {
        if (err instanceof TokenExpiredError) {
            try {
                const refresh_token = socket.handshake.auth?.refresh_token;
                if (!refresh_token) {
                    return next(new Error('Unauthorized: No refresh token provided'));
                }

                const decoded_token = jwt.verify(
                    refresh_token,
                    process.env.REFRESH_TOKEN_SECRET as string
                ) as JwtPayload;

                const refresh_access_token = await generateAccessTokenWithRefreshToken(decoded_token);
                if (refresh_access_token.httpCode !== 200) {
                    return next(new Error(refresh_access_token.error || 'Unauthorized'));
                }

                const user = jwt.verify(
                    refresh_access_token.message as string,
                    process.env.ACCESS_TOKEN_SECRET as string
                ) as UserType;

                socket.user = user;
                socket.newAccessToken = refresh_access_token.message;

                return next();
            } catch (error) {
                return next(new Error('Refresh token is invalid or expired'));
            }
        } else {
            return next(new Error('Unauthorized: Invalid token'));
        }
    }
}

