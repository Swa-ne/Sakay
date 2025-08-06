import { useAuthStore } from "@/stores";
import api from ".";
import { AxiosError } from "axios";

const ROUTE = "/report"
export const getAllReports = async (cursor?: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-all-report`,
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
export const getReport = async (report_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-report/${report_id}`,
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
export const getReportStats = async () => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.get(
            `${ROUTE}/get-stats-report`,
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
export const toggleReport = async (report_id: string) => {
    const { access_token } = useAuthStore.getState();
    try {
        const response = await api.put(
            `${ROUTE}/toggle-report/${report_id}`,
            {},
            {
                headers: {
                    "Authorization": access_token
                }
            }
        );

        const data = response.data;
        return data;
    } catch (error: unknown) {
        const axiosError = error as AxiosError<{ error: string }>;
        const errMsg = axiosError.response?.data?.error || 'Unknown error';
        return errMsg;
    }
}