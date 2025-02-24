import express from 'express';
import { Server } from "socket.io";
import http from "http";
import { socketAuthenticate } from "./middlewares/socket.token.authentication";
import { UserType } from "./middlewares/token.authentication";
import { addUserToRedisRealtimeController, addUserToRedisTrackingController, checkUserFromRedisRealtimeController, getUserFromRedisRealtimeController, removeUserFromRedisRealtimeController, removeUserFromRedisTrackingController } from "./controllers/tracking/index.controller";
import { getCurrentUserById } from './services/index.services';

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


const trackingSocket = io.of("/tracking");

trackingSocket.use(socketAuthenticate);

trackingSocket.on("connection", async (socket) => {
    if (socket.newAccessToken) {
        socket.emit('new-access-token', { access_token: socket.newAccessToken });
    }
    addUserToRedisTrackingController(socket.id, socket.user);
    // Person traker
    socket.on('track-me', async (location) => {
        socket.broadcast.emit("update-map-driver", {
            location, user: socket.user?.user_id
        });
    });

    socket.on('pause-track-me', async (location) => {
        socket.broadcast.emit("track-me-stop", {
            user: socket.user?.user_id
        });
    });

    // Vehicle tracker
    socket.on('track-my-vehicle', async (location) => {
        socket.broadcast.emit("update-map", {
            location, user: socket.user?.user_id
        });
    });

    socket.on('pause-track-my-vehicle', async (location) => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.user?.user_id
        });
    });

    socket.on("disconnect", async () => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.user?.user_id
        })
        removeUserFromRedisTrackingController(socket.id, socket.user)
    });
});
const realtimeSocket = io.of("/realtime");

realtimeSocket.use(socketAuthenticate);

realtimeSocket.on("connection", async (socket) => {
    if (socket.newAccessToken) {
        socket.emit('new-access-token', { access_token: socket.newAccessToken });
    }
    addUserToRedisRealtimeController(socket.id, socket.user?.user_id!);

    socket.on("send-msg", async (data) => {
        const sender = await getCurrentUserById(socket.user?.user_id!);
        console.log(data.receiver_id, "fjdsfjksf")
        if (data.receiver_id === "") {
            console.log("1")
            socket.broadcast.emit("msg-receive-admin", { message: data.msg, chat_id: data.chat_id, sender_id: socket.user?.user_id!, user: sender });
            return;
        }
        if (await checkUserFromRedisRealtimeController(data.receiver_id)) {
            console.log("2")
            const socket_id = await getUserFromRedisRealtimeController(data.receiver_id);
            if (socket_id) socket.to(socket_id).emit("msg-receive", { message: data.msg, chat_id: data.chat_id, sender_id: socket.user?.user_id!, user: sender });
            return;
        }
    });

    socket.on("disconnect", async () => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.id
        })
        removeUserFromRedisRealtimeController(socket.user?.user_id!)
    });
});
export { app, io, server };