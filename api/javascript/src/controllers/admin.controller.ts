import { Request, Response } from 'express';
import { assignUserToBus, deleteBus, getBus, getBusses, postBus, putBus } from '../services/admin.services';
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
        const bus = await getBusses();
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
        const user = req.user;
        const { bus_id } = req.params;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        const result = await assignUserToBus(user.user_id, bus_id);
        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }

        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
