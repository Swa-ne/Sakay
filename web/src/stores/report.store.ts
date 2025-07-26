import { FetchReportStats, Report } from '@/types';
import { create } from 'zustand';

interface ReportStore {
    reports: Report[]
    reportStats: FetchReportStats | null;

    setReports: (update: Report[] | ((prev: Report[]) => Report[])) => void
    setReportStats: (update: (FetchReportStats | null) | ((prev: (FetchReportStats | null)) => (FetchReportStats | null))) => void

    onToggleReport: (report: Report) => void
    onAdminReport: (report: Report) => void
    onAdminToggleReport: (report: Report) => void
}

const useReportStore = create<ReportStore>((set) => ({
    reports: [],
    reportStats: {
        open: {
            count: 0,
            change: 0

        }, closed: {
            count: 0,
            change: 0

        }, assigned: {
            count: 0,
            change: 0

        }, unassigned: {
            count: 0,
            change: 0

        }
    },

    setReports: (update) =>
        set((state) => ({
            reports: typeof update === 'function' ? update(state.reports) : update,
        })),
    setReportStats: (update) =>
        set((state) => ({
            reportStats: typeof update === 'function' ? update(state.reportStats) : update,
        })),

    onToggleReport: (report) =>
        set((state) => ({
            reports: state.reports.map((r) =>
                r._id === report._id
                    ? { ...r, is_open: !r.is_open }
                    : r
            ),
        })),

    onAdminReport: (report) =>
        set((state) => ({
            reports: [report, ...state.reports],
        })),

    onAdminToggleReport: (report) =>
        set((state) => ({
            reports: state.reports.map((r) =>
                r._id === report._id ? report : r
            ),
        })),
}));

export default useReportStore;

export const reportActions = {
    setReportStats: useReportStore.getState().setReportStats,
    onToggleReport: useReportStore.getState().onToggleReport,
    onAdminReport: useReportStore.getState().onAdminReport,
    onAdminToggleReport: useReportStore.getState().onAdminToggleReport,
};