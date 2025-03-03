import { Request, Response } from 'express';
import { UserType } from '../middlewares/token.authentication';
import { validateContentLength } from '../utils/input.validators';
import { getAllReports, getReport, postIncidentReport, postPerformanceReport, toggleReport } from '../services/report.services';

export const postIncidentReportController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        const { bus_id, description, place_of_incident, time_of_incident, date_of_incident } = req.body;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }

        if (!validateContentLength(description)) {
            res.status(413)
                .json({
                    error: "The description must contain between 2 and 250 words.",
                });
            return;
        }
        const requiredFields = {
            place_of_incident,
            time_of_incident,
            date_of_incident
        };

        const updatedKey: { [key: string]: string } = {
            place_of_incident: "Place of incident",
            time_of_incident: "Time of incident",
            date_of_incident: "Date of incident",
        }
        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
                return;
            }
        }

        const result = await postIncidentReport(bus_id, user.user_id, description, place_of_incident, time_of_incident, date_of_incident);

        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const postPerformanceReportController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        const { bus_id, description, driver: driver_id, driving_rate, service_rate, reliability_rate } = req.body;
        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }

        if (!bus_id) {
            res.status(404).json({ error: 'Bus not found' });
            return;
        }
        if (!driver_id) {
            res.status(404).json({ error: 'Driver not found' });
            return;
        }

        if (!validateContentLength(description)) {
            res.status(413)
                .json({
                    error: "The description must contain between 2 and 250 words.",
                });
            return;
        }
        const requiredFields = {
            driving_rate,
            service_rate,
            reliability_rate
        };

        const updatedKey: { [key: string]: string } = {
            driving_rate: "Driving rate",
            service_rate: "Service rate",
            reliability_rate: "Reliability rate",
        }
        for (const [key, value] of Object.entries(requiredFields)) {
            if (value == null) {
                res.status(400).json({ error: `${updatedKey[key]} is required and cannot be null or undefined.` });
                return;
            }
        }

        const result = await postPerformanceReport(bus_id, user.user_id, driver_id, description, driving_rate, service_rate, reliability_rate);

        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        console.log(error)
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getAllReportsController = async (req: Request, res: Response) => {
    try {
        const { page = 1 } = req.params;
        const reports = await getAllReports(page as string);

        if (reports.httpCode === 200) {
            res.status(reports.httpCode).json({ message: reports.message });
            return;
        }

        res.status(reports.httpCode).json({ error: reports.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const getReportController = async (req: Request, res: Response) => {
    try {
        const { report_id } = req.params;
        if (!report_id) {
            res.status(404).json({ error: 'Report not found' });
            return;
        }

        const report = await getReport(report_id);
        if (report.httpCode === 200) {
            res.status(report.httpCode).json({ message: report.message });
            return;
        }

        res.status(report.httpCode).json({ error: report.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};
export const toggleReportController = async (req: Request & { user?: UserType }, res: Response) => {
    try {
        const user = req.user;
        const { report_id } = req.params;

        if (!user) {
            res.status(404).json({ error: "User not found" });
            return;
        }
        if (!report_id) {
            res.status(404).json({ error: 'Report not found' });
            return;
        }

        const result = await toggleReport(user.user_id, report_id);

        if (result.httpCode === 200) {
            res.status(result.httpCode).json({ message: result.message });
            return;
        }
        res.status(result.httpCode).json({ error: result.error });
    } catch (error) {
        res.status(500).json({ error: 'Internal Server Error' });
    }
};