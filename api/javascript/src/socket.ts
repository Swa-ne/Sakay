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
        origin: '*',
        credentials: true,
    },
});

io.on("connection", async (socket) => {
    // socketAuthenticate(io);
    // if (socket.newAccessToken) {
    //     socket.emit('newAccessToken', { access_token: socket.newAccessToken });
    // }
    // addUserToRedisController(socket.id, socket.user);
    socket.on('track-my-vehicle', async (location) => {
        console.log(`location of user ${socket.id}: Longitude is ${location.longitude}, Latitude is ${location.latitude}, Speed is ${location.speed}`)
        socket.broadcast.emit("update-map", {
            location, user: socket.id
        })

    })
    socket.on('pause-track-my-vehicle', async (location) => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.id
        })

    })
    socket.on("disconnect", async () => {
        socket.broadcast.emit("track-my-vehicle-stop", {
            user: socket.id
        })
        removeUserToRedisController(socket.id, socket.user)
        console.log(`disconnected ${socket.id}`)
    });
});

export { app, io, server };