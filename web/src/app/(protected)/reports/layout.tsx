import IncidentReport from '@/components/icons/incidentReport';
import PerformanceReport from '@/components/icons/performanceReport';
import ReportStatistics from '@/components/reportStatistics';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';

export default function ReportsLayout({ children }: { children: React.ReactNode }) {
    const tabs = [
        {
            name: 'All',
        },
        {
            name: 'Incident Reports',
            icon: <IncidentReport />,
        },
        {
            name: 'Performance Reports',
            icon: <PerformanceReport />,
        },
    ];

    return (
        <div className='flex flex-col min-h-screen w-full p-5 space-y-2 overflow-hidden'>
            <div className='p-5 w-full bg-background rounded-t-2xl'>
                <h1 className='text-4xl font-bold mb-2'>Reports Statistics</h1>
                <ReportStatistics />
            </div>

            <div className='w-full flex-grow flex flex-row space-x-3 overflow-hidden h-0'>
                <div className='w-1/2 bg-background rounded-b-2xl p-5 overflow-y-auto h-full'>
                    <Tabs defaultValue={tabs[0].name} className='w-full'>
                        <TabsList className='p-0 bg-background justify-start border-b rounded-none space-x-2 mb-3'>
                            {tabs.map((tab) => (
                                <TabsTrigger key={tab.name} value={tab.name} className='rounded-none bg-background h-full data-[state=active]:shadow-none border-b-2 border-transparent data-[state=active]:border-b-primary'>
                                    <code className='text-lg'>{tab.name}</code>
                                </TabsTrigger>
                            ))}
                        </TabsList>

                        {tabs.map((tab) => (
                            <TabsContent key={tab.name} value={tab.name}>
                                <div className='h-12 flex items-center justify-between border gap-2 rounded-md pl-3 pr-1.5 cursor-pointer'>
                                    <label className='w-2/3 space-x-2 flex items-center hover:underline cursor-pointer'>
                                        {tab.icon}
                                        <b>Unit ABC</b> - See report details
                                    </label>
                                    <span>2:25 PM</span>
                                </div>
                            </TabsContent>
                        ))}
                    </Tabs>
                </div>

                <div className='w-1/2 bg-background rounded-b-2xl overflow-hidden relative h-full p-5'>{children}</div>
            </div>
        </div>
    );
}
