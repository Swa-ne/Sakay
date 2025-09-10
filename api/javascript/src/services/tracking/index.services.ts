import { redis } from "../..";

export const addUserToRedisTracking = async (type: string, socket_id: string) => {
    try {
        const redisKey = `user_sockets_tracking:${type}`;

        await redis.sAdd(redisKey, socket_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const removeUserFromRedisTracking = async (type: string, socket_id: string) => {
    try {
        const redisKey = `user_sockets_tracking:${type}`;

        await redis.sRem(redisKey, socket_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getAdminsFromRedisTracking = async () => {
    try {
        const admin = await redis.sMembers(`user_sockets_tracking:ADMIN`);
        return { message: admin, httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const addUserToRedisRealtime = async (socket_id: string, user_id: string) => {
    try {
        await redis.set(user_id, socket_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const removeUserFromRedisRealtime = async (user_id: string) => {
    try {
        await redis.del(user_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getUserFromRedisRealtime = async (user_id: string) => {
    try {
        const socket_id = await redis.get(user_id);
        return socket_id;
    } catch (err) {
        return null;
    }
}
export const checkUserFromRedisRealtime = async (user_id: string) => {
    try {
        const result = await redis.exists(user_id);
        return result;
    } catch (err) {
        return null;
    }
}
export const addBusIDToRedisRealtime = async (bus_id: string, user_id: string) => {
    try {
        await redis.set(bus_id, user_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const removeBusIDFromRedisRealtime = async (bus_id: string) => {
    try {
        await redis.del(bus_id);
        return { message: 'Success', httpCode: 200 };
    } catch (err) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const checkBusIDFromRedisRealtime = async (bus_id: string) => {
    try {
        const result = await redis.exists(bus_id);
        let user_id;
        if (result === 1) {
            user_id = await redis.get(bus_id)
        }
        return user_id;
    } catch (err) {
        return null;
    }
}
export const getBusIDFromRedisRealtime = async (bus_id: string) => {
    try {
        const socket_id = await redis.get(bus_id);
        return socket_id;
    } catch (err) {
        return null;
    }
}