'use client'
import { getAllReports, getReport, getReportStats, toggleReport } from '@/service/report';
import { toggleReportSocket } from '@/service/websocket/realtime';
import useReportStore from '@/stores/report.store';
import { Report } from '@/types';
import { useCallback, useEffect, useRef, useState } from 'react';

const useReports = () => {
    const lastFetchedCursor = useRef<string | null>(null);
    const hasLoadedAnnouncements = useRef(false);

    const [reportCursor, setReportCursor] = useState<string | null>(null)
    const [reportID, setReportID] = useState<string | undefined>()
    const [report, setReport] = useState<Report | null>()

    const reports = useReportStore((state) => state.reports);
    const setReports = useReportStore((state) => state.setReports);
    const reportStats = useReportStore((state) => state.reportStats);
    const setReportStats = useReportStore((state) => state.setReportStats);
    const onToggleReport = useReportStore((state) => state.onToggleReport);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);

    const fetchReport = useCallback(async (id: string) => {
        setLoading(true);
        setError(null);
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

    const fetchReports = useCallback(async (cursor?: string | null) => {
        setLoading(true);
        setError(null);

        const reports = await getAllReports(cursor || undefined);

        if (typeof reports === 'string') {
            setReports([]);
            setError(reports);
        } else {
            setReportCursor(reports["nextCursor"]);
            if (cursor) {
                setReports((prev) => [...prev, reports["reports"]]);
                lastFetchedCursor.current = cursor;
            } else {
                setReports(reports["reports"]);
                lastFetchedCursor.current = null;
                hasLoadedAnnouncements.current = true;
            }
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

    const toggleReportOnClick = async () => {
        if (!report) return;
        setLoading(true);
        const result = await toggleReport(report._id);
        if (result && result.message) {
            toggleReportSocket(report._id);
            onToggleReport(report);
        }
        setLoading(false);
    };


    useEffect(() => {
        fetchReportStats()
    }, [fetchReportStats])

    useEffect(() => {
        if (!hasLoadedAnnouncements.current && reports.length === 0) {
            fetchReports(reportCursor)
        }
    }, [reportCursor, fetchReports])

    const loadMoreReports = useCallback(() => {
        if (reportCursor && !loading && reportCursor !== lastFetchedCursor.current) {
            fetchReports(reportCursor);
        }
    }, [reportCursor, loading, fetchReports]);

    useEffect(() => {
        if (reportID) fetchReport(reportID)
    }, [reportID, fetchReport])

    return { loadMoreReports, report, reports, reportStats, reportID, setReport, setReports, setReportStats, setReportID, reportCursor, setReportCursor, loading, error, setLoading, toggleReportOnClick };
}

export default useReports