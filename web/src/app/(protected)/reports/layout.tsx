'use client';

import { ReactNode } from 'react';
import IncidentReport from '@/components/icons/incidentReport';
import PerformanceReport from '@/components/icons/performanceReport';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import ReportStatistics from '@/components/reportStatistics';
import { Card, CardContent } from '@/components/ui/card';
import useReports from '@/hooks/useReports';
import { TypesOfReport } from '@/types';
import { timeAgo } from '@/utils/date.util';
import LoadingPage from '@/components/pages/loading.page';
import Link from 'next/link';

export default function ReportsLayout({ children }: { children: ReactNode }) {
    const { reports, loading, error } = useReports();

    const tabs = [
        { name: 'All', value: 'all', icon: null },
        { name: 'Incident Reports', value: 'INCIDENT', icon: <IncidentReport /> },
        { name: 'Performance Reports', value: 'PERFORMANCE', icon: <PerformanceReport /> },
    ];

    // const [filterReport, setFilterReport] = useState<TypesOfReport | 'all'>('all');

    const filteredReports = (type: TypesOfReport | 'all') => reports.filter((report) => (type === 'all' ? true : report.type_of_report === type));

    if (loading) return <LoadingPage />;

    if (error) {
        // TODO: show a something
    }

    return (
        <div className='flex flex-col h-screen w-full p-3 md:p-5 space-y-4 overflow-hidden bg-gray-50'>
            <Card className='p-1 w-full shadow-sm'>
                <CardContent className='p-2 md:p-4'>
                    <div className='flex flex-col md:flex-row md:items-center md:justify-between mb-4'>
                        <div>
                            <h1 className='text-2xl md:text-4xl font-bold mb-2 text-gray-900'>Reports Statistics</h1>
                            <p className='text-sm text-gray-600'>Monitor and track all your reports in real-time</p>
                        </div>
                    </div>
                    <ReportStatistics />
                </CardContent>
            </Card>

            <div className='flex-1 flex flex-col lg:flex-row gap-4 overflow-hidden'>
                <Card className='w-full lg:w-1/2 shadow-sm'>
                    <CardContent className='p-2 md:p-4 h-full overflow-y-auto flex flex-col'>
                        <Tabs defaultValue='all' className='w-full flex-1 flex flex-col'>
                            <TabsList className='grid w-full grid-cols-3 mb-4 bg-gray-100'>
                                {tabs.map((tab) => (
                                    <TabsTrigger key={tab.value} value={tab.value} className='text-xs md:text-sm data-[state=active]:bg-white data-[state=active]:shadow-sm'>
                                        <div className='flex items-center space-x-1'>
                                            {tab.icon}
                                            <span className='hidden sm:inline'>{tab.name}</span>
                                        </div>
                                    </TabsTrigger>
                                ))}
                            </TabsList>

                            {tabs.map((tab) => (
                                <TabsContent key={tab.value} value={tab.value} className='flex-1'>
                                    <div className='space-y-3'>
                                        {filteredReports(tab.value as TypesOfReport | 'all').map((report) => (
                                            <Link href={`/reports/${report.type_of_report.toLocaleLowerCase()}/${report._id}`} key={report.description} className='flex items-center justify-between p-3 border border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors'>
                                                <div className='flex items-center space-x-3'>
                                                    <div className='text-gray-400'>{report.type_of_report === 'INCIDENT' ? <IncidentReport /> : report.type_of_report === 'PERFORMANCE' ? <PerformanceReport /> : null}</div>
                                                    <div>
                                                        <p className='font-medium text-sm'>{report.driver ? `${report.driver.first_name} ${report.driver.last_name}` : `${report.bus.bus_number} - ${report.bus.plate_number}`}</p>
                                                        <p className='text-xs text-gray-500 truncate w-2/3'>{report.description}</p>
                                                    </div>
                                                </div>
                                                {report.createdAt && <span className='text-xs text-gray-400'>{timeAgo(report.createdAt)}</span>}
                                            </Link>
                                        ))}

                                        {filteredReports(tab.value as TypesOfReport | 'all').length === 0 && <p className='text-sm text-gray-400 text-center italic'>No reports found.</p>}
                                    </div>
                                </TabsContent>
                            ))}
                        </Tabs>
                    </CardContent>
                </Card>

                <Card className='w-full lg:w-1/2 shadow-sm'>
                    <CardContent className='p-2 md:p-4 h-full overflow-y-auto'>{children}</CardContent>
                </Card>
            </div>
        </div>
    );
}
