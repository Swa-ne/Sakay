import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";
import { UserModel } from "@/schema/account.unit.schema";
import { Account } from "@/types";

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
export const postDriver = async (driver: UserModel) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.post(
            `${ROUTE}/create-driver`,
            driver,
            {
                headers: {
                    "Authorization": access_token
                }
            }
        );

        const data = response.data;
        const user: Account = {
            id: data.user_id,
            name: `${data.first_name} ${data.last_name}`,
            role: data.user_type,
            assignedUnitId: data.assigned_bus_id,
        }
        return user;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}