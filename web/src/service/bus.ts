import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";

const ROUTE = "/bus"
export const getAllBusses = async (page: number) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-busses`,
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
export const getBus = async (bus_id: string) => {
    try {
        const response = await api.get(
            `${ROUTE}/get-bus/${bus_id}`
        );

        const data = response.data;
        return data.message;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
