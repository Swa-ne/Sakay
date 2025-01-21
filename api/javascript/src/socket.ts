import { Server } from "socket.io";
import http from "http";
import { app } from ".";

const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        credentials: true,
    },
});

io.on("connection", async (socket) => {
    const userId = socket.handshake.query.userId;
    console.log(`disconnected ${userId}`)

    socket.on("disconnect", async () => {
        console.log(`disconnected ${userId}`)
    });
});

export { app, io, server };