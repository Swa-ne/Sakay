import api from ".";
import { LoginUserModel } from "@/schema/auth.schema";
import { AxiosError } from "axios";
import { useAuthStore } from "@/stores";

const ROUTE = "/authentication"
export const login = async (user: LoginUserModel) => {
    try {
        const response = await api.post(
            `${ROUTE}/login`,
            user
        );

        const data = response.data;
        useAuthStore.getState().setAll({
            access_token: data.access_token,
            user_id: data.user_id,
            first_name: data.first_name,
            last_name: data.last_name,
            email: data.email,
            profile: data.profile,
            user_type: data.user_type,
        });

        return "Success";
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}

export const authenticateToken = async () => {
    let response
    try {

        const { access_token, setAll } = useAuthStore.getState();
        response = await api.get(`${ROUTE}/current-user`, {
            headers: {
                "Authorization": access_token
            }
        });
        const response_body = response.data;

        if (response.status === 200) {
            const newAccessToken = response.headers['authorization'];
            if (newAccessToken) {
                const tokenValue = newAccessToken.split(' ')[1];
                setAll({ access_token: tokenValue });
            }

            const userType = response_body.message.user_type;
            setAll({ user_type: userType });

            return {
                is_authenticated: true,
                user_type: userType,
            };
        } else if (response.status === 401) {
            return 'Unauthorized';
        } else {
            return 'No internet connection';
        }
    } catch (error: unknown) {
        console.log(response)
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}

export const logout = async () => {
    try {

        const { access_token } = useAuthStore.getState();

        const response = await api.delete(
            `${ROUTE}/logout`, {
            headers: {
                "Authorization": access_token
            }
        });

        const data = response.data;
        if (data === "User logged Out") {
            useAuthStore.getState().reset();
            return "Success";
        }

        return "Failed";
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}