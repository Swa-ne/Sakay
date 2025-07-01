import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";
import { BusModel } from "@/schema/account.unit.schema";
import { Unit } from "@/types";

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
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-bus/${bus_id}`,
            {
                headers: {
                    "Authorization": access_token
                }
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
export const postBus = async (bus: BusModel) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.post(
            `${ROUTE}/create-bus`,
            bus,
            {
                headers: {
                    "Authorization": access_token
                }
            }
        );

        const data = response.data;
        const unit: Unit = {
            id: data.message,
            name: `${bus.bus_number} - ${bus.plate_number}`,
            bus_number: bus.bus_number,
            plate_number: bus.plate_number
        }
        return unit;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
export const assignUserToBus = async (bus_id: string, user_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.post(
            `${ROUTE}/assign-driver`,
            { bus_id, user_id },
            {
                headers: {
                    "Authorization": access_token
                }
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
export const unassignDriverToBus = async (user_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.delete(
            `${ROUTE}/remove-assign-driver`,
            {
                headers: {
                    "Authorization": access_token
                },
                data: { user_id }
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