import express, { Request, Response } from 'express';
import cors from 'cors';
import bodyParser from "body-parser";
import cookieParser from 'cookie-parser';

const app = express();

const port = 3000;


app.set('trust proxy', 1);
app.use(
    cors({
        origin: process.env.CLIENT_URL,
        credentials: true,
    })
);
app.use(express.json());
app.use(
    bodyParser.urlencoded({
        extended: true,
    }),
);
app.use(cookieParser());

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});