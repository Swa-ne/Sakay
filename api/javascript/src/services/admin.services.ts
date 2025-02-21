import { Request, Response } from "express"
import { startSession } from "mongoose";
import { Bus } from "../models/bus.model";
import { User } from "../models/authentication/user.model";
import { UserBusAssigning } from "../models/user.bus.assigning.model";

export const postBus = async (bus_number: string, plate_number: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        await new Bus({
            bus_number,
            plate_number
        }).save({ session });

        await session.commitTransaction();
        session.endSession();

        return { message: "Success", httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: "Internal Server Error", httpCode: 500 };
    }
}
export const getBusses = async () => {
    const session = await startSession();
    session.startTransaction();

    try {
        const busses = await Bus.find().session(session);

        await session.commitTransaction();
        session.endSession();

        return { message: busses, httpCode: 200 };
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

        new UserBusAssigning({
            user_id,
            bus_id,
        }).save({ session });

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}

export const reassignUserToBus = async (user_id: string, bus_id: string) => {
    const session = await startSession();
    session.startTransaction();

    try {
        const user = await UserBusAssigning.findOne({ user_id }).session(session);
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
        user.bus_id = bus._id;

        user.save({ session });

        await session.commitTransaction();
        session.endSession();

        return { message: 'Success', httpCode: 200 };
    } catch (error) {
        await session.abortTransaction();
        session.endSession();
        return { error: 'Internal Server Error', httpCode: 500 };
    }
}
