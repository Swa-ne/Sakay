'use client';

import Image from 'next/image';
import { StarRating } from '@/components/ui/star-rating';
import { Report } from '@/types';
import { useEffect, useState } from 'react';
import { getDriversSummaryByID } from '@/service/report';
import { useParams } from 'next/navigation';
import Link from 'next/link';

const DriverReportPage = () => {
    const { id } = useParams();
    const [report, setReport] = useState<Report>({} as Report);

    useEffect(() => {
        const fetchData = async () => {
            if (typeof id === 'string') {
                const response = await getDriversSummaryByID(id as string);
                setReport(response);
            }
        };
        fetchData();
    }, []);
    return (
        <div className='h-full overflow-hidden overflow-y-auto bg-white p-5 rounded-xl shadow-sm'>
            <div className='w-full flex justify-between items-center'>
                <label className='text-3xl font-bold text-gray-900'>Driver Report</label>
            </div>

            <div className='flex items-center space-x-2 p-2 mt-2'></div>
            <div className='flex'>
                <div className='w-full border-t-2 border-gray-200 p-3 mt-2'>
                    <h3 className='text-lg font-semibold mb-3'>Driver Information</h3>
                    <div className='flex items-center space-x-3'>
                        <div className='relative w-16 h-16 rounded-md overflow-hidden border-2 border-gray-300'>
                            <Image src={'/profile.jpg'} fill alt='Driver profile' className='object-cover' />
                        </div>
                        <div>
                            <h3 className='text-base font-semibold'>{report.driver_name}</h3>
                        </div>
                    </div>
                </div>
            </div>

            <div className='border-t-2 border-gray-200 mt-6 pt-4'>
                <h3 className='text-lg font-semibold mb-3'>Violations</h3>
                <div className='space-y-3'>
                    {report.reports &&
                        report.reports.map((v) => (
                            <div key={v._id} className='flex items-start justify-between p-3 border rounded-lg hover:bg-gray-50 transition'>
                                <Link href={`/reports/performance/${v._id}`}>
                                    <p className='font-semibold text-gray-800'>{v.description}</p>
                                </Link>
                            </div>
                        ))}
                </div>
            </div>
            <div className='border-t-2 border-gray-200 mt-6 pt-4'>
                <h2 className='text-xl font-bold mt-5'>Ratings</h2>
                <div className='mx-5 my-2 flex space-x-2.5 items-center'>
                    <div className='text-center border-r-2 border-black p-2'>
                        <h1 className='text-7xl font-bold'>{report.overall_average}</h1>
                    </div>
                    <StarRating value={report.overall_average ?? 0} setValue={() => {}} disabled />
                </div>

                <div className='mt-8'>
                    <div className='mx-5 my-4 flex space-x-10 items-center'>
                        <h3 className='w-16 text-lg font-semibold'>Average Driving</h3>
                        <StarRating value={report.avg_driving_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                    </div>
                    <div className='mx-5 my-4 flex space-x-10 items-center'>
                        <h3 className='w-16 text-lg font-semibold'>Average Service</h3>
                        <StarRating value={report.avg_service_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                    </div>
                    <div className='mx-5 my-4 flex space-x-10 items-center'>
                        <h3 className='w-16 text-lg font-semibold'>Average Reliability</h3>
                        <StarRating value={report.avg_reliability_rate ?? 0} setValue={() => {}} disabled starSize='size-15' />
                    </div>
                </div>
            </div>
        </div>
    );
};

export default DriverReportPage;
