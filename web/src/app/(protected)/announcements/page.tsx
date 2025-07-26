'use client';

import { Calendar, FileText, Users } from 'lucide-react';

const Announcements = () => {
    return (
        <div className='flex flex-col items-center justify-center h-full text-center p-4 space-y-4 md:space-y-6'>
            {/* Icon Container - Responsive sizing */}
            <div className='w-16 h-16 md:w-24 md:h-24 bg-muted rounded-full flex items-center justify-center'>
                <FileText className='w-8 h-8 md:w-12 md:h-12 text-muted-foreground' />
            </div>

            {/* Text Content - Responsive typography */}
            <div className='space-y-1 md:space-y-2'>
                <h2 className='text-xl md:text-2xl font-semibold text-foreground'>Select an Announcement</h2>
                <p className='text-sm md:text-base text-muted-foreground max-w-xs md:max-w-md'>
                    Choose an announcement from the list to view its full details, including content, audience, and additional information.
                </p>
            </div>

            {/* Info Cards - Responsive grid and spacing */}
            <div className='grid grid-cols-1 gap-3 md:gap-4 w-full max-w-xs md:max-w-sm'>
                <div className='flex items-center space-x-2 md:space-x-3 p-2 md:p-3 bg-muted/50 rounded-lg'>
                    <Users className='w-4 h-4 md:w-5 md:h-5 text-muted-foreground' />
                    <span className='text-xs md:text-sm text-muted-foreground'>View audience targeting</span>
                </div>

                <div className='flex items-center space-x-2 md:space-x-3 p-2 md:p-3 bg-muted/50 rounded-lg'>
                    <Calendar className='w-4 h-4 md:w-5 md:h-5 text-muted-foreground' />
                    <span className='text-xs md:text-sm text-muted-foreground'>Check publication dates</span>
                </div>

                <div className='flex items-center space-x-2 md:space-x-3 p-2 md:p-3 bg-muted/50 rounded-lg'>
                    <FileText className='w-4 h-4 md:w-5 md:h-5 text-muted-foreground' />
                    <span className='text-xs md:text-sm text-muted-foreground'>Read full content</span>
                </div>
            </div>
        </div>
    );
};

export default Announcements;