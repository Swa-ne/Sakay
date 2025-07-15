import { io, Socket } from 'socket.io-client';
import { useAuthStore } from '@/stores/auth.store';
import { chatActions } from '@/stores/chat.store';
import { announcementActions } from '@/stores/announcement.store';
import { reportActions } from '@/stores/report.store';
import { Announcement, Report, File, fetchUser } from '@/types';

const API_URL = `${process.env.NEXT_PUBLIC_API_URL}/realtime`;

export interface ChatMessagePayload {
    chat_id: string;
    message: string;
    sender_id: string;
}

export interface AnnouncementSocketPayload {
    announcement_id: string;
    posted_by: fetchUser;
    headline: string;
    content: string;
    audience: "EVERYONE" | "DRIVER" | "COMMUTER";
    files?: File[];
}

export interface ToggleReportPayload {
    report: Report;
}

let socket: Socket;

export const connectSocket = async () => {
    const { access_token } = useAuthStore.getState();

    socket = io(API_URL, {
        transports: ['websocket'],
        auth: { token: access_token },
    });

    socket.on('connect', () => {
        console.log('Connected to realtime socket');
    });

    socket.on('msg-receive', (message: ChatMessagePayload) => {
        chatActions.onReceiveMessage({
            chat_id: message.chat_id,
            message: message.message,
            sender_id: message.sender_id,
            isRead: false,
            createdAt: new Date().toString(),
            updatedAt: new Date().toString(),
        });
    });

    socket.on('announcement-receive', (data: AnnouncementSocketPayload) => {
        announcementActions.onReceiveAnnouncement({
            _id: data.announcement_id,
            posted_by: data.posted_by,
            headline: data.headline,
            content: data.content,
            audience: data.audience,
            files: (data.files || []).map((f: File) => f as File),
        });
    });

    socket.on('update-announcement-receive', (data: AnnouncementSocketPayload) => {
        announcementActions.onUpdateAnnouncement({
            _id: data.announcement_id,
            posted_by: data.posted_by,
            headline: data.headline,
            content: data.content,
            audience: data.audience,
            files: (data.files || []).map((f: File) => f as File),
        });
    });

    socket.on('toggle-report-receive', (data: ToggleReportPayload) => {
        reportActions.onToggleReport(data.report as Report);
    });

    socket.on('disconnect', () => {
        console.log('Disconnected from realtime socket');
    });

    socket.on('error', (error: unknown) => {
        console.error('Socket error:', error);
    });
};

export const connectAdminSocketEvents = () => {
    socket.on('msg-receive-admin', (message: ChatMessagePayload) => {
        chatActions.onReceiveMessage({
            chat_id: message.chat_id,
            message: message.message,
            sender_id: message.sender_id,
            isRead: false,
            createdAt: new Date().toString(),
            updatedAt: new Date().toString(),
        });
    });

    socket.on('report-receive-admin', (message: ToggleReportPayload) => {
        reportActions.onAdminReport(message.report as Report);
    });

    socket.on('toggle-report-receive-admin', (message: ToggleReportPayload) => {
        reportActions.onAdminToggleReport(message.report as Report);
    });
};

export const sendMessage = (receiver_id: string, message: string, chat_id: string) => {
    socket.emit('send-msg', { receiver_id, msg: message, chat_id });
};

export const sendAnnouncement = (announcement: Announcement) => {
    socket.emit('send-announcement', {
        headline: announcement.headline,
        content: announcement.content,
        posted_by: announcement.posted_by,
        audience: announcement.audience,
        announcement_id: announcement._id,
    });
};

export const updateAnnouncement = (announcement: Announcement) => {
    socket.emit('update-announcement', {
        headline: announcement.headline,
        content: announcement.content,
        posted_by: announcement.posted_by,
        audience: announcement.audience,
        announcement_id: announcement._id,
    });
};

export const sendReport = (report: Report) => {
    socket.emit('send-report', { report });
};

export const toggleReport = (report_id: string) => {
    socket.emit('toggle-report', { report_id });
};

export const disconnectSocket = () => {
    if (socket) socket.disconnect();
};
