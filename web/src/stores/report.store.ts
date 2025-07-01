import { FetchReportStats, Report } from '@/types';
import { create } from 'zustand';

interface ReportStore {
    reports: Report[]
    reportStats: FetchReportStats | null;

    setReports: (update: Report[] | ((prev: Report[]) => Report[])) => void
    setReportStats: (update: (FetchReportStats | null) | ((prev: (FetchReportStats | null)) => (FetchReportStats | null))) => void
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
}));

export default useReportStore;