'use client';
import Map from '@/components/map';
import UnitsContainer from '@/components/unitsContainer';
import useTracker from '@/hooks/useTracker';
import { useState } from 'react';
import LoadingPage from './loading.page';

export default function HomePage() {
    const [map, setMap] = useState<google.maps.Map | null>(null);
    const { busses, polylines, loading } = useTracker(map);

    if (loading) return <LoadingPage />;

    return (
        <div className='p-2 md:p-5 w-full h-screen flex flex-col md:flex-row gap-2 md:gap-5'>
            {/* Map Panel - 40% height on mobile, full height on desktop */}
            <div className='w-full md:w-2/3 h-[40%] md:h-full bg-background rounded-2xl overflow-hidden relative order-1 md:order-2'>
                <Map busses={busses} polylines={polylines} setMap={setMap} />
                {/* <UnitDetails status={1} /> */}
            </div>

            {/* Units List Panel - 60% height on mobile, full height on desktop */}
            <div className='w-full md:w-1/3 h-[60%] md:h-full bg-background rounded-2xl p-3 md:p-5 overflow-y-auto order-2 md:order-1'>
                <div className='w-full flex flex-col md:flex-row md:justify-between md:items-center gap-2 mb-2'>
                    <h1 className='text-2xl md:text-4xl font-bold'>Units</h1>
                    {/* <div className='flex items-center max-w-full md:max-w-sm space-x-2 rounded-lg border border-gray-300 bg-gray-50 dark:bg-gray-900 px-3.5 py-2'>
                        <Input 
                            type='search' 
                            placeholder='Search Unit' 
                            className='w-full border-0 h-8 font-semibold text-sm md:text-base' 
                        />
                    </div> */}
                </div>
                <div className='space-y-2 pt-2 overflow-y-auto h-[calc(100%-70px)]'>
                    {Array.from(busses.entries()).map(([busId, bus]) => (
                        <UnitsContainer key={busId} bus={bus} />
                    ))}
                </div>
            </div>
        </div>
    );
}
