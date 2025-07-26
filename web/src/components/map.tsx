'use client';
import { Dispatch, SetStateAction, useRef } from 'react';
import { GoogleMap, Marker, Polyline, useJsApiLoader } from '@react-google-maps/api';
import { BusInformation } from '@/types';
import LoadingPage from './pages/loading.page';

const containerStyle = {
    width: '100%',
    height: '100vh',
};

const center = {
    lat: 16.03341,
    lng: 120.286585,
};

const mapOptions = {
    zoomControl: false,
    mapTypeControl: false,
    streetViewControl: false,
    fullscreenControl: false,
    styles: [
        {
            featureType: 'poi',
            elementType: 'all',
            stylers: [{ visibility: 'off' }],
        },
    ],
};

interface MapProps {
    busses: Map<string, BusInformation>;
    polylines: never[];
    setMap: Dispatch<SetStateAction<google.maps.Map | null>>;
}
const Map = ({ busses, polylines, setMap }: MapProps) => {
    const { isLoaded } = useJsApiLoader({
        googleMapsApiKey: process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY as string,
    });

    const mapRef = useRef<google.maps.Map>(null);

    if (!isLoaded) return <LoadingPage />;

    return (
        <GoogleMap
            mapContainerStyle={containerStyle}
            center={center}
            zoom={12}
            options={{
                ...mapOptions,
                mapTypeId: 'roadmap',
            }}
            onLoad={(map) => {
                mapRef.current = map;
                setMap(mapRef.current);
            }}
        >
            {Array.from(busses.values()).map((bus) => (
                <Marker
                    key={bus._id}
                    position={{ lng: bus.longitude, lat: bus.latitude }}
                    icon={{
                        url: '/icon/bus_icon.png',
                        scaledSize: new window.google.maps.Size(40, 40),
                    }}
                    title={`Speed: ${bus.speed.toFixed(2)} km/hr`}
                />
            ))}
            {Array.from(polylines).map((polyline, index) => (
                <Polyline key={index} path={polyline} />
            ))}
        </GoogleMap>
    );
};

export default Map;
