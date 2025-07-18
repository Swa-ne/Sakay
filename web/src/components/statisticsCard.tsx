import { Account, Unit } from '@/types';
import { Users, BusFront, LifeBuoy, ShieldUser, Bus } from 'lucide-react';

interface StatisticsCard {
    title: string;
    count: number;
    icon: React.ReactNode;
    color: string;
}

export const StatisticCards = ({ accounts, units }: { accounts: Account[]; units: Unit[] }) => {
    const statisticsCards: StatisticsCard[] = [
        {
            title: 'Users',
            count: accounts.length,
            icon: <Users className='h-20 w-20' />,
            color: 'bg-sky-100 text-sky-600',
        },
        {
            title: 'Commuters',
            count: accounts.filter((a) => a.role === 'COMMUTER').length,
            icon: <BusFront className='h-20 w-20' />,
            color: 'bg-yellow-100 text-yellow-600',
        },
        {
            title: 'Drivers',
            count: accounts.filter((a) => a.role === 'DRIVER').length,
            icon: <LifeBuoy className='h-20 w-20' />,
            color: 'bg-rose-100 text-rose-600',
        },
        {
            title: 'Admin',
            count: accounts.filter((a) => a.role === 'ADMIN').length,
            icon: <ShieldUser className='h-20 w-20' />,
            color: 'bg-indigo-100 text-indigo-600',
        },
        {
            title: 'Units',
            count: units.length,
            icon: <Bus className='h-20 w-20' />,
            color: 'bg-emerald-100 text-emerald-600',
        },
    ];

    return (
        <>
            {statisticsCards.map((card, index) => (
                <div key={index} className={`w-full p-4 rounded-xl shadow-sm hover:shadow-md transition-all duration-200 flex items-center space-x-4 ${card.color}`}>
                    <div className='p-3 rounded-full flex items-center justify-center'>{card.icon}</div>
                    <div className='flex-1'>
                        <p className='text-lg font-medium text-muted-foreground'>{card.title}</p>
                        <p className='text-3xl font-bold text-foreground'>{card.count}</p>
                    </div>
                </div>
            ))}
        </>
    );
};
