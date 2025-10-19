import { allowedDestinations } from "../constant/location.points";

function haversineDistance(lat1: number, lon1: number, lat2: number, lon2: number) {
    const toRad = (value: number) => (value * Math.PI) / 180;

    const R = 6371e3;
    const φ1 = toRad(lat1);
    const φ2 = toRad(lat2);
    const Δφ = toRad(lat2 - lat1);
    const Δλ = toRad(lon2 - lon1);

    const a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
        Math.cos(φ1) * Math.cos(φ2) *
        Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
}

export function getNearestDestination(lat: number, lng: number) {
    let nearest = allowedDestinations[0];
    let minDistance = haversineDistance(lat, lng, nearest.lat, nearest.lng);

    for (const point of allowedDestinations) {
        const dist = haversineDistance(lat, lng, point.lat, point.lng);
        if (dist < minDistance) {
            minDistance = dist;
            nearest = point;
        }
    }

    return nearest.name;
}