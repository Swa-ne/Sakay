import { Button } from '@/components/ui/button';
import { Plus } from 'lucide-react';

const Announcements = () => {
    return (
        <div className='flex flex-col min-h-screen w-full p-5 space-y-2 overflow-hidden'>
            <div className='w-full flex-grow flex flex-row space-x-3 overflow-hidden h-0'>
                <div className='w-1/2 bg-background rounded-2xl p-5 overflow-y-auto h-full'>
                    <div className='w-full flex justify-between items-center mb-5'>
                        <h1 className='text-4xl font-bold'>Annoncements</h1>
                        <Button className='text-background px-4 py-5'>
                            Add Driver <Plus />
                        </Button>
                    </div>
                    <div className='h-20 flex items-center justify-between border gap-2 rounded-md pl-3 pr-1.5 cursor-pointer'>
                        <label className='w-2/3 flex flex-col justify-center hover:underline cursor-pointer'>
                            <span className='truncate w-full block'>
                                <b>Hiring</b> - WE ARE HIRING - WE ARE HIRING- WE ARE HIRING- WE ARE HIRING- WE ARE HIRING- WE ARE HIRING- WE ARE HIRING- WE ARE HIRING
                            </span>
                            <i>Drivers</i>
                        </label>
                        <span>2:25 PM</span>
                    </div>
                </div>

                <div className='w-1/2 bg-background rounded-2xl overflow-hidden relative h-full p-5'></div>
            </div>
        </div>
    );
};

export default Announcements;
