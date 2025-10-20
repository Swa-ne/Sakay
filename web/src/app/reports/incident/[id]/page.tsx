'use client';

import IncidentReport from '@/components/icons/incidentReport';
import PlaceOfIncident from '@/components/icons/placeOfIncident';
// import useManageAccounts from '@/hooks/useManageAccounts';
import useReports from '@/hooks/useReports';
import { reportDate } from '@/utils/date.util';
import Image from 'next/image';
import { useParams } from 'next/navigation';
import { useEffect } from 'react';

const IncidentPage = () => {
    // const { accounts } = useManageAccounts();
    const { id } = useParams();
    const { report, loading, error, setReportID, toggleReportOnClick } = useReports();

    useEffect(() => {
        if (typeof id === 'string') {
            setReportID(id);
        }
    }, [id, setReportID]);

    // if (loading) return <LoadingPage />;
    if (error) return <div>Error: {error}</div>;
    if (!report) return <div>Report not found</div>;

    // const adminAccounts = accounts.filter((acc) => acc.role === 'ADMIN');
    return (
        <div className='h-full overflow-hidden overflow-y-auto'>
            <div className='w-full flex justify-between items-center'>
                <label className='text-4xl font-bold mb-2'>Incident Report</label>
                <span>{reportDate(report.createdAt!)}</span>
            </div>
            <div className='w-full flex items-center space-x-1.5 p-2'>
                <IncidentReport />
                <h2 className='text-xl font-bold'>{`${report.bus.bus_number} - ${report.bus.plate_number}`}</h2>
            </div>
            {report.description && <p className='m-5'>{report.description} </p>}
            <div className='flex'>
                <div className='w-1/2 border-t-2 p-3 mt-2'>
                    <h3 className='text-lg font-semibold'>Reported by:</h3>
                    <div className='flex items-center m-5 space-x-1'>
                        <div className='relative w-15 rounded-md overflow-hidden aspect-square border-2 border-black'>
                            <Image src={'/profile.jpg'} fill className='object-fill scale-110' alt='Sakay user profile picture' />
                        </div>
                        <div className='ml-3'>
                            <h3 className='text-lg font-semibold'>{`${report.reporter?.first_name} ${report.reporter?.last_name}`}</h3>
                            <h3 className='text-lg font-semibold'>{report.reporter?.phone_number}</h3>
                        </div>
                    </div>
                </div>
                <div className='w-1/2 border-t-2 p-3 mt-2'>
                    <h3 className='text-lg font-semibold'>Place of Incident:</h3>
                    <div className='flex items-center m-5 space-x-1 cursor-pointer'>
                        <PlaceOfIncident />
                        <div className='ml-3'>
                            <h3 className='text-lg font-semibold'>{report.place_of_incident}</h3>
                            {/* <h3 className='text-lg font-semibold opacity-50 hover:underline hover:opacity-100'>View Location</h3> */}
                        </div>
                    </div>
                </div>
            </div>
            <div className='flex justify-end mb-2'>
                <button className={`px-4 py-2 rounded font-semibold ${report.is_open ? 'bg-red-500 hover:bg-red-600' : 'bg-green-500 hover:bg-green-600'} text-white disabled:opacity-50`} onClick={toggleReportOnClick} disabled={loading}>
                    {loading ? (report.is_open ? 'Closing...' : 'Reopening...') : report.is_open ? 'Close Report' : 'Reopen Report'}
                </button>
            </div>
        </div>
    );
};

export default IncidentPage;
