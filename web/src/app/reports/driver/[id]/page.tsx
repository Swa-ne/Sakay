'use client';

import Image from 'next/image';
import IncidentReport from '@/components/icons/incidentReport';
import PlaceOfIncident from '@/components/icons/placeOfIncident';

const DriverReportPage = () => {
    // dummy data
    const report = {
        createdAt: 'October 19, 2025',
        driver: {
            name: 'Juan Dela Cruz',
            id_number: 'DRV-1024',
            profile_picture_url: '/profile.jpg',
        },
        bus: {
            bus_number: 'Bus #42',
            plate_number: 'XYZ-8899',
        },
        reporter: {
            first_name: 'Angela',
            last_name: 'Cruz',
            phone_number: '0917-654-3210',
        },
        description:
            'The passenger reported the driver for multiple traffic violations during the morning trip. The driver was allegedly speeding and using his phone while driving.',
        place_of_incident: 'Dagupan City Highway',
        violations: [
            { id: 1, title: 'Overspeeding', level: 'Major', remarks: 'Exceeded 90 km/h speed limit' },
            { id: 2, title: 'Using Mobile Phone While Driving', level: 'Major', remarks: 'Seen texting during route' },
            { id: 3, title: 'Disrespectful Behavior', level: 'Minor', remarks: 'Rude to passenger complaint' },
        ],
        status: 'Open',
    };

    return (
        <div className="h-full overflow-hidden overflow-y-auto bg-white p-5 rounded-xl shadow-sm">
            {/* Header */}
            <div className="w-full flex justify-between items-center">
                <label className="text-3xl font-bold text-gray-900">Driver Report</label>
                <span className="text-gray-500">{report.createdAt}</span>
            </div>

            {/* Bus / Driver Info */}
            <div className="flex items-center space-x-2 p-2 mt-2">
                <IncidentReport />
                <h2 className="text-xl font-semibold text-gray-800">{`${report.bus.bus_number} - ${report.bus.plate_number}`}</h2>
            </div>

            {/* Description */}
            <p className="m-4 text-gray-700 leading-relaxed">{report.description}</p>

            {/* Info Sections */}
            <div className="flex">
                {/* Driver Info */}
                <div className="w-1/2 border-t-2 border-gray-200 p-3 mt-2">
                    <h3 className="text-lg font-semibold mb-3">Driver Information</h3>
                    <div className="flex items-center space-x-3">
                        <div className="relative w-16 h-16 rounded-md overflow-hidden border-2 border-gray-300">
                            <Image
                                src={report.driver.profile_picture_url}
                                fill
                                alt="Driver profile"
                                className="object-cover"
                            />
                        </div>
                        <div>
                            <h3 className="text-base font-semibold">{report.driver.name}</h3>
                            <p className="text-sm text-gray-600">ID: {report.driver.id_number}</p>
                        </div>
                    </div>
                </div>

                {/* Reporter Info */}
                <div className="w-1/2 border-t-2 border-gray-200 p-3 mt-2">
                    <h3 className="text-lg font-semibold mb-3">Reported by</h3>
                    <div className="flex items-center space-x-3">
                        <div className="relative w-16 h-16 rounded-md overflow-hidden border-2 border-gray-300">
                            <Image src="/profile.jpg" fill alt="Passenger" className="object-cover" />
                        </div>
                        <div>
                            <h3 className="text-base font-semibold">
                                {`${report.reporter.first_name} ${report.reporter.last_name}`}
                            </h3>
                            <p className="text-sm text-gray-600">{report.reporter.phone_number}</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Violations */}
            <div className="border-t-2 border-gray-200 mt-6 pt-4">
                <h3 className="text-lg font-semibold mb-3">Violations</h3>
                <div className="space-y-3">
                    {report.violations.map((v) => (
                        <div
                            key={v.id}
                            className="flex items-start justify-between p-3 border rounded-lg hover:bg-gray-50 transition"
                        >
                            <div>
                                <p className="font-semibold text-gray-800">{v.title}</p>
                                <p className="text-sm text-gray-600">{v.remarks}</p>
                            </div>
                            <span
                                className={`text-xs font-semibold px-2 py-1 rounded ${
                                    v.level === 'Major'
                                        ? 'bg-red-100 text-red-600'
                                        : 'bg-yellow-100 text-yellow-600'
                                }`}
                            >
                                {v.level}
                            </span>
                        </div>
                    ))}
                </div>
            </div>

            {/* Place of Incident */}
            <div className="border-t-2 border-gray-200 mt-6 pt-4">
                <h3 className="text-lg font-semibold mb-3">Place of Incident</h3>
                <div className="flex items-center space-x-3 cursor-pointer">
                    <PlaceOfIncident />
                    <p className="text-base font-medium text-gray-800">{report.place_of_incident}</p>
                </div>
            </div>

            {/* Status */}
            <div className="flex justify-between items-center mt-6 border-t-2 border-gray-200 pt-4">
                <div>
                    <p className="text-sm text-gray-600">Report Status:</p>
                    <p className="text-base font-semibold text-yellow-600">{report.status}</p>
                </div>
                <button className="px-4 py-2 rounded font-semibold text-white bg-red-500 hover:bg-red-600">
                    Close Report
                </button>
            </div>
        </div>
    );
};

export default DriverReportPage;
