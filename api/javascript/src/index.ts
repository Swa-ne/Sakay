import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import { createClient } from 'redis';
import cors from 'cors';
import bodyParser from "body-parser";
import cookieParser from 'cookie-parser';
import dotenv from "dotenv";
dotenv.config()

import entryRoutes from "./routes/authentication.routes";
import chatRoutes from "./routes/chat.routes";
import announcementRoutes from "./routes/announcement.routes";
import reportRoutes from "./routes/report.routes";
import busRoutes from "./routes/bus.routes";
import usersRoutes from "./routes/user.routes";

import { app, server } from './socket';



const port = Number(process.env.API_PORT);

const MONGODB_CONNECTION: any = process.env.MONGODB_CONNECTION;

mongoose
    .connect(MONGODB_CONNECTION)
    .then(() => {
        console.log('connected to MongoDB');
    })
    .catch((error) => {
        console.log('Internal Server Error');
    });

export const redis = createClient({
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
    socket: {
        host: process.env.REDIS_HOST,
        port: Number(process.env.REDIS_PORT)
    }
});
redis.on('ready', () => {
    console.log('Connected to Redis');
});

redis.on('error', (err) => {
    console.error('Redis Client Error:', err);
});
redis.connect();
app.set('trust proxy', 1);
app.use(
    cors({
        origin: process.env.CLIENT_URL,
        credentials: true,
    })
);
app.use(
    bodyParser.urlencoded({
        extended: true,
    }),
);
app.use(cookieParser());
app.use(express.json());

app.use("/authentication", entryRoutes)
app.use("/chat", chatRoutes)
app.use("/announcement", announcementRoutes)
app.use("/report", reportRoutes)
app.use("/bus", busRoutes)
app.use("/user", usersRoutes)

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

server.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});