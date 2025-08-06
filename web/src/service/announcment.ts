import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";

const ROUTE = "/announcement"
export const getAllAnnouncements = async (cursor?: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-all-announcements`,
            {
                headers: {
                    "Authorization": access_token
                },
                params: { cursor }
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
export const getAnnouncement = async (announcement_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-announcement/${announcement_id}`,
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
export const postAnnouncement = async (formData: FormData) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.post(
            `${ROUTE}/save-announcement`,
            formData,
            {
                headers: {
                    "Authorization": access_token,
                    'Content-Type': 'multipart/form-data'
                }
            }
        );

        return response;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
export const editAnnouncement = async (announcement_id: string, formData: FormData) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.put(
            `${ROUTE}/edit-announcement/${announcement_id}`,
            formData,
            {
                headers: {
                    "Authorization": access_token,
                    'Content-Type': 'multipart/form-data'
                }
            }
        );
        const data = response.data;
        return data.message === "Success";
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}
export const deleteAnnouncement = async (announcement_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.delete(
            `${ROUTE}/delete-announcement/${announcement_id}`,
            {
                headers: {
                    "Authorization": access_token
                }
            }
        );

        const data = response.data;
        return data.message === "Success";
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}