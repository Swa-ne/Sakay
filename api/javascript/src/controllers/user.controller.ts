import { Request, Response } from "express";
import { getDriver, getDrivers, getUser, getUsers } from "../services/user.services";

export const getUsersController = async (req: Request, res: Response) => {
    try {
        const { cursor, role } = req.query;
        const users = await getUsers(cursor as string, role as string);
        if (users.httpCode === 200) {
            res.status(users.httpCode).json({ message: users.message });
            return;
        }

        res.status(users.httpCode).json({ error: users.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getUserController = async (req: Request, res: Response) => {
    try {
        const { user_id } = req.params;
        if (!user_id) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const driver = await getUser(user_id);
        if (driver.httpCode === 200) {
            res.status(driver.httpCode).json({ message: driver.message });
            return;
        }

        res.status(driver.httpCode).json({ error: driver.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getDriversController = async (req: Request, res: Response) => {
    try {
        const drivers = await getDrivers();
        if (drivers.httpCode === 200) {
            res.status(drivers.httpCode).json({ message: drivers.message });
            return;
        }

        res.status(drivers.httpCode).json({ error: drivers.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getDriverController = async (req: Request, res: Response) => {
    try {
        const { user_id } = req.params;
        if (!user_id) {
            res.status(404).json({ error: 'Driver not found' });
            return;
        }

        const driver = await getDriver(user_id);
        if (driver.httpCode === 200) {
            res.status(driver.httpCode).json({ message: driver.message });
            return;
        }

        res.status(driver.httpCode).json({ error: driver.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};