'use client'
import { getAllBussesAndDriver } from '@/service/bus';
import { useAuthStore } from '@/stores';
import { LatLngLiteral, BusInformation } from '@/types';
import { getNearestDestination } from '@/utils/latlng.util';
import { useCallback, useEffect, useState } from 'react';
import { io, Socket } from 'socket.io-client';

const TRACKING_API_URL = `${process.env.NEXT_PUBLIC_API_URL}/tracking`;

let socket: Socket | null = null;
const pendingCreations = new Set<string>();

const TERMINAL_POINT = {
    lat: 16.025179,
    lng: 120.253171
}

const useTracker = (map: google.maps.Map | null = null) => {
    const [busses, setBusses] = useState<Map<string, BusInformation>>(new Map());
    const [polylines, setPolylines] = useState([]);

    const [loading, setLoading] = useState<boolean>(false);
    const [error, setError] = useState<string | null>(null);


    const createOneBus = useCallback((bus: BusInformation, position: LatLngLiteral) => {
        if (!map) return;
        setBusses((prev) => {
            const updated = new Map(prev);
            if (bus._id) {
                const location = getNearestDestination(position.lat, position.lng);
                updated.set(bus._id, {
                    bus_number: bus.bus_number,
                    plate_number: bus.plate_number,
                    location,
                    latitude: position.lat,
                    longitude: position.lng,
                    milage: 0,
                    travel_time: 0,
                    is_used: false,
                    speed: 0,
                });
            }
            return updated;
        });
    }, [map]);

    const getAllBusses = useCallback(async () => {
        setLoading(true);
        setError(null);
        const fetchBusses = await getAllBussesAndDriver()
        if (fetchBusses !== "Internal Server Error") {
            fetchBusses.map((bus: BusInformation) => createOneBus(bus, TERMINAL_POINT))
        }
    }, [createOneBus])

    const updateOneBus = useCallback((busId: string, position: google.maps.LatLngLiteral, speed: number) => {
        setBusses((prev) => {
            if (!prev.has(busId)) return prev;

            const updated = new Map(prev);
            const existing = updated.get(busId)!;

            updated.set(busId, {
                ...existing,
                latitude: position.lat,
                longitude: position.lng,
                is_used: true,
                speed,
            });

            return updated;
        });
    }, []);

    const removeOneBus = useCallback((busId: string) => {
        setBusses((prev) => {
            if (!prev.has(busId)) return prev;

            const updated = new Map(prev);
            const existing = updated.get(busId)!;

            updated.set(busId, {
                ...existing,
                latitude: 16.025179,
                longitude: 120.253171,
                is_used: false,
                speed: 0,
            });
            return updated;
        });
    }, []);

    const connectTrackingSocket = useCallback(async () => {
        if (socket && socket.connected) return;

        const { access_token } = useAuthStore.getState();

        socket = io(TRACKING_API_URL, {
            transports: ['websocket'],
            auth: { token: access_token },
        });

        socket.connect();

        socket.on('connect', () => {
            console.log('Connected to tracking sockets');
        });

        socket.on('update-map', async (data: { user: string; location: BusInformation }) => {
            const busLoc: BusInformation = data.location;

            // if (!busses.has(data.user)) {
            if (!pendingCreations.has(data.user)) {
                pendingCreations.add(data.user);
                const bus_id = Array.from(busses.entries()).find(
                    ([, info]) => info.assignedDriverId === data.user
                )?.[0];
                if (bus_id) {
                    // createOneBus(data.user, { lng: busLoc.longitude, lat: busLoc.latitude }, busLoc.speed);
                    updateOneBus(data.user, { lng: busLoc.longitude, lat: busLoc.latitude }, busLoc.speed);
                }
                pendingCreations.delete(data.user);
            }
            // } else {
            // }
        });

        socket.on('track-my-vehicle-stop', async (data: { user: string }) => {
            removeOneBus(data.user);
        });

        socket.on('disconnect', () => {
            console.log('Disconnected from tracking socket');
        });

        socket.on('error', (error: unknown) => {
            console.error('Tracking socket error:', error);
        });
    }, []);

    const disconnectTrackingSocket = () => {
        socket?.disconnect();
        socket = null;
    };

    useEffect(() => {
        if (!map) return;

        getAllBusses();
        connectTrackingSocket();
    }, [map, getAllBusses, connectTrackingSocket]);

    return { connectTrackingSocket, disconnectTrackingSocket, busses, setBusses, polylines, setPolylines, loading, setLoading, error, setError };
}

export default useTracker