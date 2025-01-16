import express, { Request, Response } from 'express';

const app = express();

const port = 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
    res.send('Hello from your Node.js Express server!');
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});