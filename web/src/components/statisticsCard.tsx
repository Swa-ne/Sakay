import { Unit } from '@/types';
import { Users, BusFront, LifeBuoy, ShieldUser, Bus } from 'lucide-react';

interface StatisticsCard {
    title: string;
    count: number;
    icon: React.ReactNode;
    color: string;
}

interface StatisticCardsProps {
    units: Unit[];
    total: number;
    commuterCount: number;
    driverCount: number;
    adminCount: number;
}

export const StatisticCards = ({ units, total, commuterCount, driverCount, adminCount }: StatisticCardsProps) => {
    const statisticsCards: StatisticsCard[] = [
        {
            title: 'Users',
            count: total,
            icon: <Users className='h-12 w-12 sm:h-16 sm:w-16 lg:h-20 lg:w-20' />,
            color: 'bg-sky-100 text-sky-600',
        },
        {
            title: 'Commuters',
            count: commuterCount,
            icon: <BusFront className='h-12 w-12 sm:h-16 sm:w-16 lg:h-20 lg:w-20' />,
            color: 'bg-yellow-100 text-yellow-600',
        },
        {
            title: 'Drivers',
            count: driverCount,
            icon: <LifeBuoy className='h-12 w-12 sm:h-16 sm:w-16 lg:h-20 lg:w-20' />,
            color: 'bg-rose-100 text-rose-600',
        },
        {
            title: 'Admin',
            count: adminCount,
            icon: <ShieldUser className='h-12 w-12 sm:h-16 sm:w-16 lg:h-20 lg:w-20' />,
            color: 'bg-indigo-100 text-indigo-600',
        },
        {
            title: 'Units',
            count: units.length,
            icon: <Bus className='h-12 w-12 sm:h-16 sm:w-16 lg:h-20 lg:w-20' />,
            color: 'bg-emerald-100 text-emerald-600',
        },
    ];

    return (
        <div className='h-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-1 gap-3 sm:gap-4'>
            {statisticsCards.map((card, index) => (
                <div key={index} className={`w-full p-3 sm:p-4 rounded-xl shadow-sm hover:shadow-md transition-all duration-200 flex items-center space-x-2 sm:space-x-4 ${card.color}`}>
                    <div className='p-2 sm:p-3 rounded-full flex items-center justify-center'>{card.icon}</div>
                    <div className='flex-1'>
                        <p className='text-sm sm:text-lg font-medium text-muted-foreground'>{card.title}</p>
                        <p className='text-xl sm:text-2xl lg:text-3xl font-bold text-foreground'>{card.count}</p>
                    </div>
                </div>
            ))}
        </div>
    );
};
