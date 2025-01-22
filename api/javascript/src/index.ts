import express, { Request, Response } from 'express';
import mongoose from 'mongoose';
import { createClient } from 'redis';
import cors from 'cors';
import bodyParser from "body-parser";
import cookieParser from 'cookie-parser';
import dotenv from "dotenv";

import entryRoutes from "./routes/authentication.routes";
import { server } from './socket';

export const app = express();


dotenv.config()
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

const redis = createClient({
    username: process.env.REDIS_USERNAME,
    password: process.env.REDIS_PASSWORD,
    socket: {
        host: process.env.REDIS_HOST,
        port: Number(process.env.REDIS_PORT)
    }
});
redis.on('ready', () => {
    console.log('Connected to Redis Client');
});

redis.on('error', (err) => {
    console.error('Redis Client Error:', err);
});

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

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

server.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});