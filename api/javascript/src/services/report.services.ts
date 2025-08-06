import { ObjectId, Schema, startSession } from "mongoose";
import { Report } from "../models/report.model";
import { User } from "../models/authentication/user.model";
import { Bus } from "../models/bus.model";
import { startOfWeek, subWeeks } from "date-fns";

export const postIncidentReport = async (bus_id: string, user_id: string, description: string, place_of_incident: string, time_of_incident: string, date_of_incident: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const user = await User.findById(user_id).session(session);
        const bus = await Bus.findById(bus_id).session(session);

        if (!bus) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Bus not found', httpCode: 404 };
        }
        if (!user) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'User not found', httpCode: 404 };
        }

        await new Report({
            bus: bus._id,
            reporter: user._id,
            type_of_report: "INCIDENT",
            description,
            place_of_incident,
            time_of_incident,
            date_of_incident,
        }).save({ session })

        await session.commitTransaction();
        session.endSession();
        return { message: "Success", httpCode: 200 };
    }
    catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const postPerformanceReport = async (bus_id: string, user_id: string, driver_id: string, description: string, driving_rate: number, service_rate: number, reliability_rate: number) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const user = await User.findById(user_id).session(session);
        const driver = await User.findById(driver_id).session(session);
        const bus = await Bus.findById(bus_id).session(session);

        if (!bus) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Bus not found', httpCode: 404 };
        }
        if (!user) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'User not found', httpCode: 404 };
        }
        if (!driver) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Driver not found', httpCode: 404 };
        }

        await new Report({
            bus: bus._id,
            reporter: user._id,
            driver: driver._id,
            type_of_report: "PERFORMANCE",
            description,
            driving_rate,
            service_rate,
            reliability_rate,
        }).save({ session })

        await session.commitTransaction();
        session.endSession();
        return { message: "Success", httpCode: 200 };
    }
    catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getAllReports = async (cursor?: string) => {
    const session = await startSession();
    session.startTransaction();
    try {
        const query: any = {};
        if (cursor) {
            query.createdAt = { $lt: new Date(cursor) };
        }
        const reports = await Report.find(query)
            .sort({ createdAt: -1 })
            .populate("bus")
            .populate("investigator")
            .populate("reporter")
            .populate("driver")
            .limit(300)
            .session(session);
        const nextCursor = reports.length > 0 ? reports[reports.length - 1].createdAt : null;

        await session.commitTransaction();
        session.endSession();
        return { message: { reports, nextCursor }, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getReport = async (report_id: string) => {
    const session = await startSession();
    session.startTransaction();
    try {
        const report = await Report.findById(report_id)
            .populate("bus")
            .populate("investigator")
            .populate("reporter")
            .populate("driver")
            .session(session);


        await session.commitTransaction();
        session.endSession();

        if (!report) {
            return { error: "Report not found", httpCode: 404 };
        }
        return { message: report, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const toggleReport = async (user_id: string, report_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const user = await User.findById(user_id).session(session);

        if (!user) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'User not found', httpCode: 404 };
        }

        const report = await Report.findById(report_id)
            .session(session);

        if (!report) {
            await session.abortTransaction();
            session.endSession();
            return { error: "Report not found", httpCode: 404 };
        }

        report.is_open = !report.is_open;
        report.investigator = user._id;

        await report.save({ session });

        await session.commitTransaction();
        session.endSession();
        return { message: "Success", httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
};
export const getReportStats = async () => {
    try {
        const now = new Date();
        const startOfThisWeek = startOfWeek(now, { weekStartsOn: 1 });
        const startOfLastWeek = subWeeks(startOfThisWeek, 1);
        const endOfLastWeek = startOfThisWeek;

        const [
            openNow,
            openLastWeek,
            closedNow,
            closedLastWeek,
            assignedNow,
            assignedLastWeek,
            unassignedNow,
            unassignedLastWeek
        ] = await Promise.all([
            Report.countDocuments({ is_open: true }),
            Report.countDocuments({ is_open: true, createdAt: { $gte: startOfLastWeek, $lt: endOfLastWeek } }),

            Report.countDocuments({ is_open: false }),
            Report.countDocuments({ is_open: false, createdAt: { $gte: startOfLastWeek, $lt: endOfLastWeek } }),

            Report.countDocuments({ investigator: { $exists: true } }),
            Report.countDocuments({ investigator: { $exists: true }, createdAt: { $gte: startOfLastWeek, $lt: endOfLastWeek } }),

            Report.countDocuments({ investigator: { $exists: false } }),
            Report.countDocuments({ investigator: { $exists: false }, createdAt: { $gte: startOfLastWeek, $lt: endOfLastWeek } }),
        ]);

        return {
            message: {
                open: { count: openNow, change: openNow - openLastWeek },
                closed: { count: closedNow, change: closedNow - closedLastWeek },
                assigned: { count: assignedNow, change: assignedNow - assignedLastWeek },
                unassigned: { count: unassignedNow, change: unassignedNow - unassignedLastWeek },
            },
            httpCode: 200,
        };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
};