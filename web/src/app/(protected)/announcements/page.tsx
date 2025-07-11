'use client';

import { Calendar, FileText, Users } from 'lucide-react';

const Announcements = () => {
    return (
        <div className='flex flex-col items-center justify-center h-full text-center space-y-6'>
            <div className='w-24 h-24 bg-muted rounded-full flex items-center justify-center'>
                <FileText className='w-12 h-12 text-muted-foreground' />
            </div>

            <div className='space-y-2'>
                <h2 className='text-2xl font-semibold text-foreground'>Select an Announcement</h2>
                <p className='text-muted-foreground max-w-md'>Choose an announcement from the list to view its full details, including content, audience, and additional information.</p>
            </div>

            <div className='grid grid-cols-1 gap-4 w-full max-w-sm'>
                <div className='flex items-center space-x-3 p-3 bg-muted/50 rounded-lg'>
                    <Users className='w-5 h-5 text-muted-foreground' />
                    <span className='text-sm text-muted-foreground'>View audience targeting</span>
                </div>

                <div className='flex items-center space-x-3 p-3 bg-muted/50 rounded-lg'>
                    <Calendar className='w-5 h-5 text-muted-foreground' />
                    <span className='text-sm text-muted-foreground'>Check publication dates</span>
                </div>

                <div className='flex items-center space-x-3 p-3 bg-muted/50 rounded-lg'>
                    <FileText className='w-5 h-5 text-muted-foreground' />
                    <span className='text-sm text-muted-foreground'>Read full content</span>
                </div>
            </div>
        </div>
    );
};

export default Announcements;
