import { Mail } from 'lucide-react';
import Image from 'next/image';
import { Button } from './ui/button';

interface UnitDetailsProps {
    status: number;
}
const UnitDetails = ({ status }: UnitDetailsProps) => {
    const label = [
        { status: 'On Service', color: '#28a745' },
        { status: 'Inactive', color: '#ffc107' },
        { status: 'Unavailable', color: '#dc3545' },
    ];

    const current = label[status];

    return (
        <div className='absolute w-full h-1/4 p-5 bottom-0 left-0'>
            <div className='w-full h-full bg-background rounded-xl p-5 flex space-x-2'>
                <div className='w-1/2 h-full border-r-[1px] border-r-primary'>
                    <h1 className='text-3xl font-bold flex space-x-5 items-center'>
                        <label>UNIT1-17A</label>
                        <span
                            className={`inline-flex items-center px-3 py-1 text-sm font-medium border rounded-full`}
                            style={{
                                color: current.color,
                                backgroundColor: `${current.color}20`,
                                borderColor: `${current.color}80`,
                            }}
                        >
                            <span className={`w-2 h-2 mr-2 bg-[${label[status].color}] rounded-full`}></span>
                            {label[status].status}
                        </span>
                    </h1>
                    <p className='text-md line-clamp-2'>28WV+R2R, Arellano St, Downtown District, Dagupan, 2400 Pangasinan</p>
                    <div className='w-full flex items-center justify-center space-x-2 mt-5 p-5'>
                        <div className='w-1/2 h-10 flex items-center bg-blue-100 text-blue-700 px-2 py-1 rounded-sm text-lg justify-center self-stretch'>
                            <svg className='w-8 h-8 mr-1' fill='currentColor' viewBox='0 0 20 20'>
                                <path d='M10 2a6 6 0 00-6 6c0 4.25 6 10 6 10s6-5.75 6-10a6 6 0 00-6-6zm0 8a2 2 0 110-4 2 2 0 010 4z' />
                            </svg>
                            2 km
                        </div>
                        <div className='w-1/2 h-10 flex items-center bg-gray-100 text-gray-800 px-2 py-1 rounded-sm text-lg justify-center self-stretch'>
                            <svg className='w-8 h-8 mr-1' fill='currentColor' viewBox='0 0 20 20'>
                                <path d='M10 2a8 8 0 100 16 8 8 0 000-16zm.5 4a.5.5 0 00-1 0v5a.5.5 0 00.276.447l3 1.5a.5.5 0 00.448-.894L10.5 10.2V6z' />
                            </svg>
                            2h 36m
                        </div>
                    </div>
                </div>
                <div className='w-1/2 h-full'>
                    <div className='h-full flex rounded-md'>
                        <div className='relative h-full aspect-square rounded-xl overflow-hidden mr-5'>
                            <Image src='/profile.jpg' fill className='object-cover ' alt='Sakay user profile picture' />
                        </div>
                        <div className='flex flex-col'>
                            <p className='text-3xl font-semibold text-ellipsis whitespace-nowrap overflow-hidden'>Swaners</p>
                            <p className='text-md text-ellipsis whitespace-nowrap overflow-hidden'>swane@gmail.com</p>
                            <Button className='bg-primary hover:bg-primary/90 text-white text-base px-6 py-3 rounded-sm mt-4' size='lg'>
                                <Mail className='w-4 h-4 mr-2' />
                                Contact Now
                            </Button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default UnitDetails;
