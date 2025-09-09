import { Request, Response } from 'express';
import { assignUserToBus, deleteBus, getBus, getBusses, getBussesAndAllDrivers, getBusWithUserID, postBus, putBus, removeAssignUserToBus } from '../services/bus.services';
import { UserType } from '../middlewares/token.authentication';

export const postBusController = async (req: Request, res: Response) => {
    try {
        const { bus_number, plate_number } = req.body;

        if (!bus_number || !plate_number) {
            res.status(400).json({ error: 'Bad Request' });
            return;
        }

        const result = await postBus(bus_number, plate_number);

        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getBussesController = async (req: Request, res: Response) => {
    try {
        const { cursor } = req.query;
        const bus = await getBusses(cursor as string);
        if (bus.httpCode === 200) {
            res.status(bus.httpCode).json({ message: bus.message });
            return;
        }

        res.status(bus.httpCode).json({ error: bus.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getBussesAndAllDriversController = async (req: Request, res: Response) => {
    try {
        const bus = await getBussesAndAllDrivers();
        if (bus.httpCode === 200) {
            res.status(bus.httpCode).json({ message: bus.message });
            return;
        }

        res.status(bus.httpCode).json({ error: bus.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getBusController = async (req: Request, res: Response) => {
    try {
        const { bus_id } = req.params;
        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const bus = await getBus(bus_id);
        if (bus.httpCode === 200) {
            res.status(bus.httpCode).json({ message: bus.message });
            return;
        }

        res.status(bus.httpCode).json({ error: bus.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getBusWithUserIDController = async (req: Request, res: Response) => {
    try {
        const { user_id } = req.params;
        if (!user_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const bus = await getBusWithUserID(user_id);
        if (bus.httpCode === 200) {
            res.status(bus.httpCode).json({ message: bus.message });
            return;
        }

        res.status(bus.httpCode).json({ error: bus.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const putBusController = async (req: Request, res: Response) => {
    try {
        const { bus_number, plate_number } = req.body;

        if (!bus_number || !plate_number) {
            res.status(400).json({ error: 'Bad Request' });
            return;
        }

        const { bus_id } = req.params;
        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const result = await putBus(bus_id, bus_number, plate_number);

        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const deleteBusController = async (req: Request, res: Response) => {
    try {
        const { bus_id } = req.params;
        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const result = await deleteBus(bus_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const assignUserToBusController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const { bus_id, user_id } = req.body;

        if (!user_id) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const result = await assignUserToBus(user_id, bus_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};

export const removeAssignUserToBusController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const { user_id } = req.body;

        if (!user_id) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        const result = await removeAssignUserToBus(user_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
