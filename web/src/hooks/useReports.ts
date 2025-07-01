'use client'
import { getAllReports, getReport, getReportStats } from '@/service/report';
import useReportStore from '@/stores/report.store';
import { Report } from '@/types';
import { useCallback, useEffect, useState } from 'react';

const useReports = () => {
    const [reportPage, setReportPage] = useState<number>(1)
    const [reportID, setReportID] = useState<string | undefined>()
    const [report, setReport] = useState<Report | null>()

    const reports = useReportStore((state) => state.reports);
    const setReports = useReportStore((state) => state.setReports);
    const reportStats = useReportStore((state) => state.reportStats);
    const setReportStats = useReportStore((state) => state.setReportStats);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const fetchReport = useCallback(async (id: string) => {
        setLoading(true);
        setError(null);
        console.log(reports)

        const cached = reports.find((r) => r._id === id);

        if (cached) {
            setReport(cached);
            setLoading(false);
            return;
        }

        const fetched = await getReport(id);

        if (typeof fetched === 'string') {
            setReport(null);
            setError(fetched);
        } else {
            setReport(fetched);
        }

        setLoading(false);
    }, [reports, setReport]);

    const fetchReports = useCallback(async (currentPage: number) => {
        setLoading(true);
        setError(null);

        const reports = await getAllReports(currentPage);

        if (typeof reports === 'string') {
            setReports([]);
            setError(reports);
        } else {
            setReports(reports);
        }
        setLoading(false);
    }, [setReports]);


    const fetchReportStats = useCallback(async () => {
        setLoading(true);
        setError(null);

        const reports = await getReportStats();

        if (typeof reports === 'string') {
            setReportStats(null);
            setError(reports);
        } else {
            setReportStats(reports);
        }
        setLoading(false);
    }, [setReportStats]);

    // const handleAssignToAdmin = async (report_id: string, selectedAdmin: string) => {
    //     if (!selectedAdmin) return;

    //     try {
    //         // Replace with your actual API call
    //         console.log(`Assigning report ${id} to admin ${selectedAdmin}`);
    //         // await assignReportToAdmin(id, selectedAdmin);
    //         alert(`Report assigned to admin successfully!`);
    //     } catch (error) {
    //         console.error('Error assigning report:', error);
    //         alert('Failed to assign report to admin');
    //     }
    // };

    // const handleCloseTicket = async () => {
    //     setIsClosing(true);
    //     try {
    //         // Replace with your actual API call
    //         console.log(`Closing ticket ${id}`);
    //         // await closeTicket(id);
    //         alert('Ticket closed successfully!');
    //     } catch (error) {
    //         console.error('Error closing ticket:', error);
    //         alert('Failed to close ticket');
    //     } finally {
    //         setIsClosing(false);
    //     }
    // };


    useEffect(() => {
        fetchReportStats()
    }, [fetchReportStats])

    useEffect(() => {
        fetchReports(reportPage)
    }, [reportPage, fetchReports])

    useEffect(() => {
        if (reportID) fetchReport(reportID)
    }, [reportID, fetchReport])

    return { report, reports, reportStats, reportID, setReport, setReports, setReportStats, setReportID, reportPage, loading, error, setReportPage, setLoading };
}

export default useReports