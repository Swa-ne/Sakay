import { redis } from "../..";

export const addUserToRedis = async (type: string, socket_id: string) => {
    try {
        const redisKey = `user_sockets:${type}`;

        await redis.sAdd(redisKey, socket_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const removeUserToRedis = async (type: string, socket_id: string) => {
    try {
        const redisKey = `user_sockets:${type}`;

        await redis.sRem(redisKey, socket_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}