import axios from 'axios';

const api = axios.create({
    baseURL: process.env.API_URL as string,
    withCredentials: true,
    headers: {
        'Content-Type': 'application/json',
    },
});

export default api;