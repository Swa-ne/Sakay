'use client';

import AddAnnouncementModal from '@/components/addAnnouncementModal';
import { Button } from '@/components/ui/button';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import useAnnouncement from '@/hooks/useAnnouncement';
import { timeAgo } from '@/utils/date.util';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { ReactNode, useEffect, useRef, useState } from 'react';

const AnnouncementsLayouts = ({ children }: { children: ReactNode }) => {
    const announcementRef = useRef<HTMLDivElement>(null);

    const { announcements, loadMoreAnnouncements } = useAnnouncement();
    const [openAnnouncementModal, setOpenAnnouncementModal] = useState(false);

    useEffect(() => {
        const container = announcementRef.current;
        if (!container) return;
        const handleScroll = () => {
            const isAtTop = container.scrollHeight - container.scrollTop - container.clientHeight <= 100;
            if (isAtTop) {
                loadMoreAnnouncements();
            }
        };

        container.addEventListener('scroll', handleScroll);

        return () => {
            container.removeEventListener('scroll', handleScroll);
        };
    }, [loadMoreAnnouncements]);

    return (
        <div className='flex flex-col min-h-screen w-full p-3 md:p-5 space-y-2 md:space-y-3 overflow-hidden'>
            <div className='w-full flex-grow flex flex-col lg:flex-row gap-3 md:gap-5 overflow-hidden h-0'>
                <div ref={announcementRef} className='w-full lg:w-1/2 bg-background rounded-xl md:rounded-2xl p-3 md:p-5 overflow-y-auto h-full'>
                    <div className='w-full flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3 mb-3 md:mb-5'>
                        <h1 className='text-2xl sm:text-3xl md:text-4xl font-bold'>Announcements</h1>

                        <Dialog open={openAnnouncementModal} onOpenChange={setOpenAnnouncementModal}>
                            <DialogTrigger asChild>
                                <Button className='text-background px-3 py-3 sm:px-4 sm:py-5 text-sm md:text-base'>
                                    <span className='hidden sm:inline'>Post Announcement</span>
                                    <span className='sm:hidden'>Post</span>
                                    <Plus className='w-4 h-4 ml-1' />
                                </Button>
                            </DialogTrigger>
                            <AddAnnouncementModal setOpen={setOpenAnnouncementModal} />
                        </Dialog>
                    </div>
                    {announcements.map((ann) => (
                        <Link href={`/announcements/${ann._id}`} key={ann._id} className='h-16 md:h-20 flex items-center justify-between border gap-2 rounded-md p-2 md:pl-3 md:pr-1.5 cursor-pointer mb-2'>
                            <label className='w-2/3 flex flex-col justify-center hover:underline cursor-pointer'>
                                <span className='truncate w-full block text-sm md:text-base'>
                                    <b>{ann.headline}</b> - {ann.content.substring(0, 30)}
                                    {ann.content.length > 30 ? '...' : ''}
                                </span>
                                <i className='text-xs md:text-sm'>{ann.audience}</i>
                            </label>
                            <span className='text-xs md:text-sm whitespace-nowrap'>{timeAgo(ann.updatedAt ?? '')}</span>
                        </Link>
                    ))}
                </div>

                <div className='w-full lg:w-1/2 bg-background rounded-xl md:rounded-2xl overflow-hidden relative h-full p-3 md:p-5'>{children}</div>
            </div>
        </div>
    );
};

export default AnnouncementsLayouts;
