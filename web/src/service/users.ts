import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";

const ROUTE = "/user"
export const getAllUsers = async (page: number) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-all-users`,
            {
                headers: {
                    "Authorization": access_token
                },
                params: { page }
            }
        );
        const data = response.data;
        return data.message;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
export const getUser = async (user_id: string) => {
    try {
        const response = await api.get(
            `${ROUTE}/get-user/${user_id}`
        );

        const data = response.data;
        return data.message;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
