import { Clock, CheckCircle, AlertCircle, UserX } from 'lucide-react';
import CircularPercentage from './icons/circularPercentage';

interface StatusCard {
    title: string;
    count: number;
    change: number;
    icon: React.ReactNode;
    color: string;
}

const ReportStatistics = () => {
    const statusCards: StatusCard[] = [
        {
            title: 'New',
            count: 53,
            change: 9,
            icon: <Clock className='h-15 w-15' />,
            color: 'bg-blue-100 text-blue-600',
        },
        {
            title: 'Open',
            count: 32,
            change: 19,
            icon: <AlertCircle className='h-15 w-15' />,
            color: 'bg-orange-100 text-orange-600',
        },
        {
            title: 'Unassigned',
            count: 12,
            change: 19,
            icon: <UserX className='h-15 w-15' />,
            color: 'bg-purple-100 text-purple-600',
        },
        {
            title: 'Closed',
            count: 76,
            change: 23,
            icon: <CheckCircle className='h-15 w-15' />,
            color: 'bg-green-100 text-green-600',
        },
    ];

    return (
        <div className='w-full space-y-6 mt-3' id='reports'>
            <div className='flex justify-around items-center'>
                <div className='w-1/4 flex flex-col items-center justify-center'>
                    <div className='relative w-32 h-32'>
                        <CircularPercentage percent={45} />
                    </div>
                    <p className='text-xl font-medium'>Total</p>
                </div>

                <div className='w-3/4 flex justify-between items-center space-x-3'>
                    {statusCards.map((card, index) => (
                        <div key={index} className='w-1/4 p-6'>
                            <div className='flex items-center space-x-3'>
                                <div className={`p-2 rounded-full ${card.color} mr-5`}>{card.icon}</div>
                                <div className='space-y-2'>
                                    <p className='text-xl font-medium'>{card.title}</p>
                                    <p className='text-5xl font-bold'>{card.count}</p>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default ReportStatistics;
