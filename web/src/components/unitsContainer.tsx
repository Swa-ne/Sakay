import Image from 'next/image';

const UnitsContainer = () => {
    return (
        <div className='w-full h-20 flex bg-background rounded-md space-x-1 cursor-pointer'>
            <div className='w-1/5 flex justify-center items-center rounded-md bg-primary'>
                <Image src='/logo.png' width={55} height={24} alt='Sakay Logo' />
            </div>
            <div className='flex w-4/5 space-x-1.5'>
                <div className='w-2/3'>
                    <h3 className='text-lg font-semibold'>UNIT1-17A</h3>
                    <p className='text-sm line-clamp-2'>28WV+R2R, Arellano St, Downtown District, Dagupan, 2400 Pangasinan</p>
                </div>
                <div className='w-1/3 flex flex-col items-center justify-center'>
                    <div className='flex items-center bg-blue-100 text-blue-700 px-2 py-1 rounded-sm text-xs justify-center self-stretch'>
                        <svg className='w-4 h-4 mr-1' fill='currentColor' viewBox='0 0 20 20'>
                            <path d='M10 2a6 6 0 00-6 6c0 4.25 6 10 6 10s6-5.75 6-10a6 6 0 00-6-6zm0 8a2 2 0 110-4 2 2 0 010 4z' />
                        </svg>
                        2 km
                    </div>
                    <div className='flex items-center bg-gray-100 text-gray-800 px-2 py-1 rounded-sm text-xs justify-center self-stretch'>
                        <svg className='w-4 h-4 mr-1' fill='currentColor' viewBox='0 0 20 20'>
                            <path d='M10 2a8 8 0 100 16 8 8 0 000-16zm.5 4a.5.5 0 00-1 0v5a.5.5 0 00.276.447l3 1.5a.5.5 0 00.448-.894L10.5 10.2V6z' />
                        </svg>
                        2h 36m
                    </div>
                </div>
            </div>
        </div>
    );
};

export default UnitsContainer;
