import mongoose, { ObjectId, Schema, startSession, Types } from "mongoose";
import { Report } from "../models/report.model";
import { User } from "../models/authentication/user.model";
import { Bus } from "../models/bus.model";
import { startOfWeek, subWeeks } from "date-fns";
import { redis } from "..";
import { getNearestDestination } from "../utils/latlng.util";
import { emitReportToAdmin } from "../socket";

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
export const updateAdminReport = async () => {

    const now = new Date();
    const time_of_incident = now.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
    });
    const date_of_incident = now.toLocaleDateString('en-US', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
    });

    try {
        const overspeedKeys = await redis.keys("overspeed:*");
        const offrouteKeys = await redis.keys("offroute:*");
        const alerts = [];

        const allKeys = [...overspeedKeys, ...offrouteKeys];

        for (const key of allKeys) {
            const busId = key.split(":")[1];
            const type = key.startsWith("overspeed:") ? "overspeed" : "offroute";

            const locationKey = `driver:${busId}:location`;
            const locData = await redis.hGetAll(locationKey);

            const lat = parseFloat(locData.lat);
            const lng = parseFloat(locData.lng);

            if (isNaN(lat) || isNaN(lng)) {
                console.warn(`No location data found for bus ${busId}`);
                continue;
            }

            const place_of_incident = getNearestDestination(lat, lng);

            const description =
                type === "overspeed"
                    ? "Driver oversped"
                    : "Driver went off route";

            alerts.push({
                bus_id: busId,
                type,
                lat,
                lng,
                message:
                    type === "overspeed"
                        ? `Bus ${busId} exceeded the speed limit.`
                        : `Bus ${busId} went off its assigned route.`,
            });

            const report = await new Report({
                bus: busId,
                reporter: "Automation",
                type_of_report: "INCIDENT",
                description,
                place_of_incident,
                time_of_incident,
                date_of_incident,
            }).save();
            emitReportToAdmin(report)
        }

        return { message: "Success", httpCode: 200, alerts };
    } catch (error) {
        return { error: "Internal Server Error", httpCode: 500 };
    }
};
export const getDriverPerformanceSummary = async () => {
    const summary = await Report.aggregate([
        { $match: { type_of_report: "PERFORMANCE" } },
        {
            $group: {
                _id: "$driver",
                total_reports: { $sum: 1 },
                avg_driving_rate: { $avg: "$driving_rate" },
                avg_service_rate: { $avg: "$service_rate" },
                avg_reliability_rate: { $avg: "$reliability_rate" },
            },
        },
        {
            $addFields: {
                overall_average: {
                    $avg: [
                        "$avg_driving_rate",
                        "$avg_service_rate",
                        "$avg_reliability_rate",
                    ],
                },
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "_id",
                foreignField: "_id",
                as: "driver",
            },
        },
        { $unwind: { path: "$driver", preserveNullAndEmptyArrays: true } },
        {
            $lookup: {
                from: "reports",
                localField: "_id",
                foreignField: "driver",
                as: "reports",
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "reports.reporter",
                foreignField: "_id",
                as: "reporters",
            },
        },
        {
            $lookup: {
                from: "buses",
                localField: "reports.bus",
                foreignField: "_id",
                as: "buses",
            },
        },
        {
            $addFields: {
                reports: {
                    $map: {
                        input: "$reports",
                        as: "r",
                        in: {
                            _id: "$$r._id",
                            description: "$$r.description",
                            driving_rate: "$$r.driving_rate",
                            service_rate: "$$r.service_rate",
                            reliability_rate: "$$r.reliability_rate",
                            createdAt: "$$r.createdAt",
                            reporter: {
                                $arrayElemAt: [
                                    {
                                        $filter: {
                                            input: "$reporters",
                                            as: "u",
                                            cond: { $eq: ["$$u._id", "$$r.reporter"] },
                                        },
                                    },
                                    0,
                                ],
                            },
                            bus: {
                                $arrayElemAt: [
                                    {
                                        $filter: {
                                            input: "$buses",
                                            as: "b",
                                            cond: { $eq: ["$$b._id", "$$r.bus"] },
                                        },
                                    },
                                    0,
                                ],
                            },
                        },
                    },
                },
            },
        },
        {
            $project: {
                _id: 0,
                driver_id: "$driver._id",
                driver_name: {
                    $concat: ["$driver.first_name", " ", "$driver.last_name"]
                },
                driver_email: "$driver.email_address",
                driver_createdAt: "$driver.createdAt",
                driver_profile_picture_url: "$driver.profile_picture_url",
                total_reports: 1,
                avg_driving_rate: { $round: ["$avg_driving_rate", 2] },
                avg_service_rate: { $round: ["$avg_service_rate", 2] },
                avg_reliability_rate: { $round: ["$avg_reliability_rate", 2] },
                overall_average: { $round: ["$overall_average", 2] },
                reports: {
                    _id: 1,
                    description: 1,
                    driving_rate: 1,
                    service_rate: 1,
                    reliability_rate: 1,
                    createdAt: 1,
                    "reporter._id": 1,
                    "reporter.name": 1,
                    "bus._id": 1,
                    "bus.plate_number": 1,
                },
            },
        },
    ]);
    return summary;
};
export const getDriverPerformanceSummaryById = async (driverId: string) => {
    const driverObjectId = new mongoose.Types.ObjectId(driverId);
    const summary = await Report.aggregate([
        {
            $match: {
                type_of_report: "PERFORMANCE",
                driver: driverObjectId,
            },
        },
        {
            $group: {
                _id: "$driver",
                total_reports: { $sum: 1 },
                avg_driving_rate: { $avg: "$driving_rate" },
                avg_service_rate: { $avg: "$service_rate" },
                avg_reliability_rate: { $avg: "$reliability_rate" },
            },
        },
        {
            $addFields: {
                overall_average: {
                    $avg: [
                        "$avg_driving_rate",
                        "$avg_service_rate",
                        "$avg_reliability_rate",
                    ],
                },
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "_id",
                foreignField: "_id",
                as: "driver",
            },
        },
        { $unwind: { path: "$driver", preserveNullAndEmptyArrays: true } },
        {
            $lookup: {
                from: "reports",
                localField: "_id",
                foreignField: "driver",
                as: "reports",
            },
        },
        {
            $lookup: {
                from: "users",
                localField: "reports.reporter",
                foreignField: "_id",
                as: "reporters",
            },
        },
        {
            $lookup: {
                from: "buses",
                localField: "reports.bus",
                foreignField: "_id",
                as: "buses",
            },
        },
        {
            $addFields: {
                reports: {
                    $map: {
                        input: "$reports",
                        as: "r",
                        in: {
                            _id: "$$r._id",
                            description: "$$r.description",
                            driving_rate: "$$r.driving_rate",
                            service_rate: "$$r.service_rate",
                            reliability_rate: "$$r.reliability_rate",
                            createdAt: "$$r.createdAt",
                            reporter: {
                                $arrayElemAt: [
                                    {
                                        $filter: {
                                            input: "$reporters",
                                            as: "u",
                                            cond: { $eq: ["$$u._id", "$$r.reporter"] },
                                        },
                                    },
                                    0,
                                ],
                            },
                            bus: {
                                $arrayElemAt: [
                                    {
                                        $filter: {
                                            input: "$buses",
                                            as: "b",
                                            cond: { $eq: ["$$b._id", "$$r.bus"] },
                                        },
                                    },
                                    0,
                                ],
                            },
                        },
                    },
                },
            },
        },
        {
            $project: {
                _id: 0,
                driver_id: "$driver._id",
                driver_name: {
                    $concat: ["$driver.first_name", " ", "$driver.last_name"],
                },
                driver_email: "$driver.email_address",
                driver_createdAt: "$driver.createdAt",
                driver_profile_picture_url: "$driver.profile_picture_url",
                total_reports: 1,
                avg_driving_rate: { $round: ["$avg_driving_rate", 2] },
                avg_service_rate: { $round: ["$avg_service_rate", 2] },
                avg_reliability_rate: { $round: ["$avg_reliability_rate", 2] },
                overall_average: { $round: ["$overall_average", 2] },
                reports: {
                    _id: 1,
                    description: 1,
                    driving_rate: 1,
                    service_rate: 1,
                    reliability_rate: 1,
                    createdAt: 1,
                    "reporter._id": 1,
                    "reporter.first_name": 1,
                    "reporter.last_name": 1,
                    "bus._id": 1,
                    "bus.plate_number": 1,
                },
            },
        },
        { $limit: 1 },
    ]);

    console.log(summary);
    return summary[0] || null;
};