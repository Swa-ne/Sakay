import { Request, Response } from "express"
import { startSession } from "mongoose";
import { Bus } from "../models/bus.model";

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