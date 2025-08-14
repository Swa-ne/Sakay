import { UserType } from "../../middlewares/token.authentication"
import { addUserToRedisTracking, removeUserFromRedisTracking, addUserToRedisRealtime, removeUserFromRedisRealtime, getUserFromRedisRealtime, checkUserFromRedisRealtime, getAdminsFromRedisTracking, checkBusIDFromRedisRealtime, addBusIDToRedisRealtime, removeBusIDFromRedisRealtime } from "../../services/tracking/index.services";

export const addUserToRedisTrackingController = async (socket_id: string, user?: UserType) => {
    try {
        if (!user) return { error: "User not found" }
        const result = await addUserToRedisTracking(user.user_type, socket_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}

export const removeUserFromRedisTrackingController = async (socket_id: string, user?: UserType) => {
    try {
        if (!user) return { error: "User not found" }
        const result = await removeUserFromRedisTracking(user.user_type, socket_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const getAdminsFromRedisTrackingController = async () => {
    try {
        const result = await getAdminsFromRedisTracking()
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const addUserToRedisRealtimeController = async (socket_id: string, user_id: string) => {
    try {
        if (!user_id) return { error: "User not found" }
        const result = await addUserToRedisRealtime(socket_id, user_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const removeUserFromRedisRealtimeController = async (user_id: string) => {
    try {
        if (!user_id) return { error: "User not found" }
        const result = await removeUserFromRedisRealtime(user_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const getUserFromRedisRealtimeController = async (user_id: string) => {
    try {
        if (!user_id) return null
        const result = await getUserFromRedisRealtime(user_id)
        return result
    } catch (error) {
        return null
    }
}
export const checkUserFromRedisRealtimeController = async (user_id: string) => {
    try {
        if (!user_id) return { error: "User not found" }
        const result = await checkUserFromRedisRealtime(user_id);
        return result
    } catch (error) {
        return null
    }
}
export const addBusIDToRedisRealtimeControllerController = async (bus_id: string, user_id: string) => {
    try {
        if (!bus_id) return { error: "User not found" }
        const result = await addBusIDToRedisRealtime(bus_id, user_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const removeBusIDFromRedisRealtimeController = async (bus_id: string) => {
    try {
        if (!bus_id) return { error: "User not found" }
        const result = await removeBusIDFromRedisRealtime(bus_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}
export const checkBusIDFromRedisRealtimeController = async (bus_id?: string) => {
    try {
        if (!bus_id) return { error: "User not found" }
        const result = await checkBusIDFromRedisRealtime(bus_id);
        return result
    } catch (error) {
        return null
    }
}