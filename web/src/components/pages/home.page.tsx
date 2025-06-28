import SearchIcon from '@/components/icons/searchIcon';
import Map from '@/components/map';
import { Input } from '@/components/ui/input';
import UnitDetails from '@/components/unitDetails';
import UnitsContainer from '@/components/unitsContainer';

export default function HomePage() {
    return (
        <div className='p-5 w-full h-screen flex space-x-5'>
            <div className='w-1/3 bg-background rounded-2xl p-5 overflow-y-auto'>
                <div className='w-full flex justify-between items-center'>
                    <h1 className='text-4xl font-bold mb-2'>Units</h1>
                    <div className='flex items-center max-w-sm space-x-2 rounded-lg border border-gray-300 bg-gray-50 dark:bg-gray-900 px-3.5 py-2'>
                        <SearchIcon />
                        <Input type='search' placeholder='Search Unit' className='w-full border-0 h-8 font-semibold' />
                    </div>
                </div>
                <div className='space-y-2 pt-2'>
                    {Array(22)
                        .fill(null)
                        .map((_, i) => (
                            <UnitsContainer key={i} />
                        ))}
                </div>
            </div>
            <div className='w-2/3 h-full bg-background rounded-2xl overflow-hidden relative'>
                <Map />
                <UnitDetails status={1} />
            </div>
        </div>
    );
}
