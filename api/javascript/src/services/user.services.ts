import { startSession } from "mongoose";
import { User } from "../models/authentication/user.model";
import { UserBusAssigning } from "../models/user.bus.assigning.model";

export const getUsers = async (cursor?: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        let total = 0;
        let commuterCount = 0;
        let driverCount = 0;
        let adminCount = 0;

        if (!cursor) {
            total = await User.countDocuments();
            commuterCount = await User.countDocuments({ user_type: 'COMMUTER' });
            driverCount = await User.countDocuments({ user_type: 'DRIVER' });
            adminCount = await User.countDocuments({ user_type: 'ADMIN' });
        }

        const query: any = {};
        if (cursor) {
            query.createdAt = { $lt: new Date(cursor) };
        }

        const users = await User.find(query)
            .sort({ createdAt: -1 })
            .limit(15)
            .session(session);

        const updatedUsers = await Promise.all(
            users.map(async (user) => {
                const userObj: any = user.toObject();
                if (user.user_type === 'DRIVER') {
                    const assignedBus = await UserBusAssigning.findOne({
                        user_id: user._id,
                    });

                    userObj.assigned_bus_id = assignedBus?.bus_id ?? null;
                } else {
                    userObj.assigned_bus_id = null;
                }

                return userObj;
            })
        );

        await session.commitTransaction();
        session.endSession();

        const nextCursor = updatedUsers.length > 0 ? updatedUsers[updatedUsers.length - 1].createdAt : null;

        return {
            message: {
                total,
                commuterCount,
                driverCount,
                adminCount,
                users: updatedUsers,
                nextCursor
            },
            httpCode: 200
        };
    } catch (error) {
        console.log(error)
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
};
export const getUser = async (user_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const user = await User.findById(user_id).session(session);

        await session.commitTransaction();
        session.endSession();

        if (!user) {
            return { error: 'User not found', httpCode: 404 };
        }

        return { message: user, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getDrivers = async () => {
    const session = await startSession();
    session.startTransaction();

    try {
        const drivers = await User.find({ user_type: "DRIVER" })
            .session(session);

        await session.commitTransaction();
        session.endSession();
        return { message: drivers, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getDriver = async (user_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const driver = await User.findById(user_id).session(session);

        await session.commitTransaction();
        session.endSession();

        if (!driver) {
            return { error: 'Driver not found', httpCode: 404 };
        }

        return { message: driver, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}