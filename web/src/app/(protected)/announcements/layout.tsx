'use client';

import AddAnnouncementModal from '@/components/addAnnouncementModal';
import { Button } from '@/components/ui/button';
import { Dialog, DialogTrigger } from '@/components/ui/dialog';
import useAnnouncement from '@/hooks/useAnnouncement';
import { timeAgo } from '@/utils/date.util';
import { Plus } from 'lucide-react';
import Link from 'next/link';
import { ReactNode, useState } from 'react';

const AnnouncementsLayouts = ({ children }: { children: ReactNode }) => {
    const { announcements } = useAnnouncement();
    const [openAnnouncementModal, setOpenAnnouncementModal] = useState(false);
    return (
        <div className='flex flex-col min-h-screen w-full p-5 space-y-2 overflow-hidden'>
            <div className='w-full flex-grow flex flex-row space-x-3 overflow-hidden h-0'>
                <div className='w-1/2 bg-background rounded-2xl p-5 overflow-y-auto h-full'>
                    <div className='w-full flex justify-between items-center mb-5'>
                        <h1 className='text-4xl font-bold'>Annoncements</h1>

                        <Dialog open={openAnnouncementModal} onOpenChange={setOpenAnnouncementModal}>
                            <DialogTrigger asChild>
                                <Button className='text-background px-4 py-5'>
                                    Add Driver <Plus />
                                </Button>
                            </DialogTrigger>
                            <AddAnnouncementModal setOpen={setOpenAnnouncementModal} />
                        </Dialog>
                    </div>
                    {announcements.map((ann) => (
                        <Link href={`/announcements/${ann._id}`} key={ann._id} className='h-20 flex items-center justify-between border gap-2 rounded-md pl-3 pr-1.5 cursor-pointer mb-2'>
                            <label className='w-2/3 flex flex-col justify-center hover:underline cursor-pointer'>
                                <span className='truncate w-full block'>
                                    <b>{ann.headline}</b> - {ann.content}
                                </span>
                                <i>{ann.audience}</i>
                            </label>
                            <span>{timeAgo(ann.updatedAt ?? '')}</span>
                        </Link>
                    ))}
                </div>

                <div className='w-1/2 bg-background rounded-2xl overflow-hidden relative h-full p-5'>{children}</div>
            </div>
        </div>
    );
};

export default AnnouncementsLayouts;
