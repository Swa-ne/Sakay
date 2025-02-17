import express from 'express';
import { Server } from "socket.io";
import http from "http";
import { socketAuthenticate } from "./middlewares/socket.token.authentication";
import { UserType } from "./middlewares/token.authentication";
import { addUserToRedisController, removeUserToRedisController } from "./controllers/tracking/index.controller";

declare module "socket.io" {
    interface Socket {
        user?: UserType;
        newAccessToken?: string;
    }
}

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
    cors: {
        origin: '*',
        credentials: true,
    },
});

io.on("connection", async (socket) => {
    // socketAuthenticate(io);
    // if (socket.newAccessToken) {
    //     socket.emit('newAccessToken', { access_token: socket.newAccessToken });
    // }
    addUserToRedisController(socket.id, socket.user);
    // Person traker
    socket.on('track-me', async (location) => {
        socket.broadcast.emit("update-map-driver", {
            location, user: socket.id
        });
    });

    socket.on('pause-track-me', async (location) => {
        socket.broadcast.emit("track-me-stop", {
            user: socket.id
        });
    });

    // Vehicle tracker
    socket.on('track-my-vehicle', async (location) => {
        socket.broadcast.emit("update-map", {
            location, user: socket.id
        });
    });

    socket.on('pause-track-my-vehicle', async (location) => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.id
        });
    });

    socket.on("disconnect", async () => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.id
        })
        removeUserToRedisController(socket.id, socket.user)
        console.log(`disconnected ${socket.id}`)
    });
});

export { app, io, server };