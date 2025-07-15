import { create } from 'zustand';
import { Announcement } from '@/types';

interface AnnouncementStore {
    announcements: Announcement[]
    setAnnouncements: (update: Announcement[] | ((prev: Announcement[]) => Announcement[])) => void
    onReceiveAnnouncement: (announcement: Announcement) => void
    onUpdateAnnouncement: (announcement: Announcement) => void
}

const useAnnouncementStore = create<AnnouncementStore>((set) => ({
    announcements: [],
    setAnnouncements: (update) =>
        set((state) => ({
            announcements: typeof update === 'function' ? update(state.announcements) : update,
        })),
    onReceiveAnnouncement: (announcement) =>
        set((state) => ({
            announcements: [announcement, ...state.announcements],
        })),

    onUpdateAnnouncement: (announcement) =>
        set((state) => ({
            announcements: state.announcements.map((a) =>
                a._id === announcement._id ? announcement : a
            ),
        })),
}));

export default useAnnouncementStore;

export const announcementActions = {
    onReceiveAnnouncement: useAnnouncementStore.getState().onReceiveAnnouncement,
    onUpdateAnnouncement: useAnnouncementStore.getState().onUpdateAnnouncement,
};