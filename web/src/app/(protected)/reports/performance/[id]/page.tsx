'use client';

import { useEffect } from 'react';
import { useParams } from 'next/navigation';
import Image from 'next/image';

import { StarRating } from '@/components/ui/star-rating';
// import { Button } from '@/components/ui/button';
// import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';

import useReports from '@/hooks/useReports';
import { reportDate } from '@/utils/date.util';
// import useManageAccounts from '@/hooks/useManageAccounts';

const PerformancePage = () => {
    // const { accounts } = useManageAccounts();
    const { id } = useParams();
    const { report, loading, error, setReportID } = useReports();
    // const [selectedAdmin, setSelectedAdmin] = useState<string>('');
    // const [isClosing, setIsClosing] = useState(false);

    // const admins = accounts.filter((acc) => acc.role === 'ADMIN');

    useEffect(() => {
        if (typeof id === 'string') {
            setReportID(id);
        }
    }, [id, setReportID]);

    if (loading) return <div>Loading...</div>;

    if (error) return <div>Error: {error}</div>;

    if (!report) return <div>Report not found</div>;

    const aveRating = Math.floor(((report.driving_rate ?? 0) + (report.service_rate ?? 0) + (report.reliability_rate ?? 0)) / 3);

    return (
        <div className='h-full overflow-hidden overflow-y-auto pb-5'>
            <div className='w-full flex justify-between items-center mb-4'>
                <label className='text-4xl font-bold mb-2'>Performance Report</label>
                <span>{reportDate(report.createdAt!)}</span>
            </div>

            {/* <div className='bg-gray-50 p-4 rounded-lg mb-4 border'>
                <h3 className='text-lg font-semibold mb-3'>Admin Actions</h3>
                <div className='flex flex-col sm:flex-row gap-3 items-start sm:items-end'>
                    <div className='flex-1 min-w-0'>
                        <label className='block text-sm font-medium mb-1'>Assign to Admin</label>
                        <Select value={selectedAdmin} onValueChange={setSelectedAdmin}>
                            <SelectTrigger className='w-full'>
                                <SelectValue placeholder='Select an admin' />
                            </SelectTrigger>
                            <SelectContent>
                                {admins.map((admin) => (
                                    <SelectItem key={admin.id} value={admin.id}>
                                        <div className='flex flex-col'>
                                            <span className='font-medium'>{admin.name}</span>
                                            <span className='text-xs text-gray-500'>{admin.email}</span>
                                        </div>
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    </div>
                    <div className='flex gap-2'>
                        <Button onClick={handleAssignToAdmin} disabled={!selectedAdmin} variant='outline'>
                            Assign
                        </Button>
                        <Button onClick={handleCloseTicket} disabled={isClosing} variant='destructive'>
                            {isClosing ? 'Closing...' : 'Close Ticket'}
                        </Button>
                    </div>
                </div>
            </div> */}

            <div className='p-3'>
                <div className='w-full h-36 flex items-center space-x-1.5 rounded-2xl overflow-hidden shadow-[0px_4px_10px_rgba(0,0,0,0.15)]'>
                    <div className='w-1/5 h-full flex justify-center items-center bg-primary'>
                        <div className='relative h-30 rounded-full overflow-hidden aspect-square'>
                            <Image src={report.driver?.profile_picture_url || '/profile.jpg'} fill className='object-fill scale-110' alt='Profile' />
                        </div>
                    </div>
                    <div className='flex-1 h-full p-5'>
                        <div className='flex justify-end'>
                            <h3 className='text-lg font-semibold'>{`${report.bus.bus_number} - ${report.bus.plate_number}`}</h3>
                        </div>
                        <div>
                            <h2 className='text-xl font-bold'>{`${report.driver?.first_name} ${report.driver?.last_name}`}</h2>
                            <span className='text-md opacity-50'>{report.driver?.phone_number}</span>
                        </div>
                    </div>
                </div>

                <div className='mt-5'>
                    {report.description && (
                        <>
                            <h2 className='text-xl font-bold'>Feedback</h2>
                            <p className='mx-5 my-2'>{report.description}</p>
                        </>
                    )}

                    <h2 className='text-xl font-bold mt-5'>Ratings</h2>
                    <div className='mx-5 my-2 flex space-x-2.5 items-center'>
                        <div className='text-center border-r-2 border-black p-2'>
                            <h1 className='text-7xl font-bold'>{aveRating}</h1>
                            {/* <label className='opacity-40'>Based on {report.ratingCount ?? 0} ratings</label> */}
                        </div>
                        <StarRating value={aveRating} setValue={() => {}} disabled />
                    </div>

                    <div className='mt-8'>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Driving</h3>
                            <StarRating value={report.driving_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                        </div>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Service</h3>
                            <StarRating value={report.service_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                        </div>
                        <div className='mx-5 my-4 flex space-x-10 items-center'>
                            <h3 className='w-16 text-lg font-semibold'>Reliability</h3>
                            <StarRating value={report.reliability_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PerformancePage;
