import { UserType } from "../../middlewares/token.authentication"
import { addUserToRedis, removeUserToRedis } from "../../services/tracking/index.services";

export const addUserToRedisController = async (socket_id: string, user?: UserType) => {
    try {
        if (!user) return { error: "User not found" }
        const result = await addUserToRedis(user.user_type, socket_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}

export const removeUserToRedisController = async (socket_id: string, user?: UserType) => {
    try {
        if (!user) return { error: "User not found" }
        const result = await removeUserToRedis(user.user_type, socket_id)
        if (result.httpCode === 500) return { error: result.error }
        return { message: result.message }
    } catch (error) {
        return { error: "Internal Server Error" }
    }
}