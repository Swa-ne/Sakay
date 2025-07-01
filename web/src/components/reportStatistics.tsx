import type React from 'react';
import { CheckCircle, AlertCircle, UserX, Users } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import CircularPercentage from './icons/circularPercentage';
import useReports from '@/hooks/useReports';

interface StatusCard {
    title: string;
    count: number;
    change: number;
    icon: React.ReactNode;
    color: string;
}
const ReportStatistics = () => {
    const { reportStats } = useReports();

    const closedReports = reportStats?.closed.count ?? 0;
    const openReports = reportStats?.open.count ?? 0;

    const statusCards: StatusCard[] = [
        {
            title: 'Open',
            count: reportStats?.open.count ?? 0,
            change: reportStats?.open.change ?? 0,
            icon: <AlertCircle className='h-10 w-10' />,
            color: 'bg-orange-50 text-orange-600 border-orange-200',
        },
        {
            title: 'Closed',
            count: closedReports,
            change: reportStats?.closed.change ?? 0,
            icon: <CheckCircle className='h-10 w-10' />,
            color: 'bg-green-50 text-green-600 border-green-200',
        },
        {
            title: 'Unassigned',
            count: reportStats?.unassigned.count ?? 0,
            change: reportStats?.unassigned.change ?? 0,
            icon: <UserX className='h-10 w-10' />,
            color: 'bg-purple-50 text-purple-600 border-purple-200',
        },
        {
            title: 'Assigned',
            count: reportStats?.assigned.count ?? 0,
            change: reportStats?.assigned.change ?? 0,
            icon: <Users className='h-10 w-10' />,
            color: 'bg-indigo-50 text-indigo-600 border-indigo-200',
        },
    ];

    const totalReports = openReports + closedReports;

    const completionRate = totalReports > 0 ? Math.round((closedReports / totalReports) * 100) : 0;

    return (
        <div className='w-full space-y-6 mt-3' id='reports'>
            <div className='flex flex-col lg:flex-row gap-6 items-center'>
                <Card className='p-0 w-full lg:w-auto lg:min-w-[280px] border-2 border-dashed border-gray-200'>
                    <CardContent className='p-2 flex  items-center justify-around text-center'>
                        <div className='relative w-28 h-28'>
                            <CircularPercentage percent={completionRate} />
                        </div>
                        <div className='space-y-1'>
                            <p className='text-3xl font-bold text-gray-900'>{totalReports}</p>
                            <p className='text-sm font-medium text-gray-600'>Total Reports</p>
                            <p className='text-xs text-gray-500'>{completionRate}% completion rate</p>
                        </div>
                    </CardContent>
                </Card>

                <div className='flex-1 w-full'>
                    <div className='grid grid-cols-2 md:grid-cols-4 lg:grid-cols-4 xl:grid-cols-4 gap-3'>
                        {statusCards.map((card, index) => (
                            <Card key={index} className={`${card.color} border transition-all duration-200 cursor-pointer py-4`}>
                                <CardContent className='p-4 flex space-x-2 items-center'>
                                    <div className='flex items-start justify-between'>
                                        <div className={`p-2 rounded-lg ${card.color.replace('border-', 'bg-').replace('50', '100')}`}>{card.icon}</div>
                                    </div>
                                    <div className='space-y-1'>
                                        <p className='text-md font-medium text-gray-600 uppercase tracking-wide'>{card.title}</p>
                                        <div className='flex space-x-4 items-center'>
                                            <p className='text-3xl font-bold'>{card.count}</p>
                                            <div className={`w-fit h-fit text-sm px-1 py-0.5 rounded-full ${card.change >= 0 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                                                {card.change >= 0 ? '+' : ''}
                                                {card.change}
                                            </div>
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default ReportStatistics;
