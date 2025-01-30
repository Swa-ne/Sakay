import { Server } from "socket.io";
import http from "http";
import { app } from ".";
import { socketAuthenticate } from "./middlewares/socket.token.authentication";
import { UserType } from "./middlewares/token.authentication";
import { addUserToRedisController, removeUserToRedisController } from "./controllers/tracking/index.controller";

declare module "socket.io" {
    interface Socket {
        user?: UserType;
        newAccessToken?: string;
    }
}

const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: process.env.CLIENT_URL,
        credentials: true,
    },
});

io.on("connection", async (socket) => {
    socketAuthenticate(io);
    if (socket.newAccessToken) {
        socket.emit('newAccessToken', { access_token: socket.newAccessToken });
    }
    addUserToRedisController(socket.id, socket.user);
    socket.on('track-me', async (location) => {
        console.log(`location of user ${socket.user?.full_name}: Longitude is ${location.longitude}, Latitude is ${location.latitude}, Speed is ${location.speed}`)
    })
    socket.on("disconnect", async () => {
        removeUserToRedisController(socket.id, socket.user)
        console.log(`disconnected ${socket.id}`)
    });
});

export { app, io, server };