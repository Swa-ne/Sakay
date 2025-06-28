import { startSession } from "mongoose";
import { User } from "../models/authentication/user.model";
import { UserBusAssigning } from "../models/user.bus.assigning.model";

export const getUsers = async (page: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const users = await User.find()
            .skip((parseInt(page) - 1) * 15)
            .limit(30)
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

        return { message: updatedUsers, httpCode: 200 };
    } catch (error) {
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