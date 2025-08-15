import { startSession } from "mongoose";
import { Bus } from "../models/bus.model";
import { User } from "../models/authentication/user.model";
import { UserBusAssigning } from "../models/user.bus.assigning.model"; import { startOfDay, differenceInDays } from "date-fns";
import { emitBusCreated, emitDriverAssigned, emitDriverUnassigned } from "../socket";

export const postBus = async (bus_number: string, plate_number: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await new Bus({
            bus_number,
            plate_number
        }).save({ session });

        await session.commitTransaction();
        session.endSession();
        emitBusCreated(bus);
        return { message: bus._id, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getBusses = async (cursor?: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const query: any = {};
        if (cursor) {
            query.createdAt = { $lt: new Date(cursor) };
        }
        const busses = await Bus.find(query)
            .sort({ createdAt: -1 })
            .limit(30)
            .session(session);

        await session.commitTransaction();
        session.endSession();
        const busesWithDrivers = await Promise.all(
            busses.map(async (bus) => {
                const driver = await getTodayDriver(bus._id.toString());
                return { ...bus.toObject(), today_driver: driver?.message };
            })
        );
        const nextCursor = busses.length > 0 ? busses[busses.length - 1].createdAt : null;

        return { message: { busesWithDrivers, nextCursor }, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getBussesAndAllDrivers = async () => {
    const session = await startSession();
    session.startTransaction();

    try {
        const busses = await Bus.find()
            .session(session);

        await session.commitTransaction();
        session.endSession();
        const busesWithDrivers = await Promise.all(
            busses.map(async (bus) => {
                const driver = await getBusDriver(bus._id.toString());
                return { ...bus.toObject(), current_driver: driver?.message };
            })
        );
        return { message: busesWithDrivers, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getBus = async (bus_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await Bus.findById(bus_id).session(session);

        await session.commitTransaction();
        session.endSession();

        if (!bus) {
            return { error: 'Bus not found', httpCode: 404 };
        }

        return { message: bus, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getBusWithUserID = async (user_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await UserBusAssigning.findById(user_id).session(session);

        await session.commitTransaction();
        session.endSession();

        if (!bus) {
            return { error: 'Driver is not assigned yet.', httpCode: 404 };
        }

        return { message: bus.bus_id, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const putBus = async (bus_id: string, bus_number: string, plate_number: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await Bus.findByIdAndUpdate(
            bus_id,
            {
                bus_number,
                plate_number
            },
            { new: true }
        );
        if (!bus) {
            return { error: "Bus not found", httpCode: 404 };
        }
        await session.commitTransaction();
        session.endSession();

        return { message: "Success", httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const deleteBus = async (bus_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await Bus.findByIdAndDelete(bus_id).session(session);

        if (!bus) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Bus not found', httpCode: 404 };
        }

        await UserBusAssigning.deleteMany({ bus_id }).session(session);

        await session.commitTransaction();
        session.endSession();

        if (!bus) {
            return { error: 'Bus not found', httpCode: 404 };
        }

        return { message: "Success", httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const assignUserToBus = async (user_id: string, bus_id: string) => {
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

        await new UserBusAssigning({
            user_id,
            bus_id,
        }).save({ session });

        await session.commitTransaction();
        session.endSession();
        emitDriverAssigned(user_id, bus_id);
        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}
export const removeAssignUserToBus = async (user_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const result = await UserBusAssigning.findOneAndDelete({ user_id }).session(session);

        if (!result) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'User assignment not found', httpCode: 404 };
        }

        await session.commitTransaction();
        session.endSession();
        emitDriverUnassigned(user_id);
        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}
export const getTodayDriver = async (bus_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await Bus.findById(bus_id).session(session);

        if (!bus) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Bus not found', httpCode: 404 };
        }
        const drivers = await UserBusAssigning.find({ bus_id, is_active: true })
            .sort({ createdAt: 1 })
            .populate("user_id")
            .session(session);

        if (drivers.length === 0) return { message: null, httpCode: 200 };

        const daysElapsed = differenceInDays(startOfDay(new Date()), startOfDay(new Date(1640121596152)));

        return { message: drivers[daysElapsed % drivers.length].user_id, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}
export const getBusDriver = async (bus_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const bus = await Bus.findById(bus_id).session(session);

        if (!bus) {
            await session.abortTransaction();
            session.endSession();
            return { error: 'Bus not found', httpCode: 404 };
        }
        const drivers = await UserBusAssigning.find({ bus_id, is_active: true })
            .sort({ createdAt: 1 })
            .populate("user_id")
            .session(session);

        if (drivers.length === 0) return { message: null, httpCode: 200 };

        return { message: drivers, httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
};