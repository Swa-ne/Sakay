'use client';
import { useContext, useRef } from 'react';
import { GoogleMap, Marker, Polyline, useJsApiLoader } from '@react-google-maps/api';
// import { MapContext } from './MapContext';

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
const Map = () => {
    const { isLoaded } = useJsApiLoader({
        googleMapsApiKey: process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY as string,
    });
    //   const {
    //     markers,
    //     polylines,
    //     showMyLocation,
    //   } = useContext(MapContext);

    // const mapRef = useRef(null);

    if (!isLoaded) return <div>Loading...</div>;

    return (
        <GoogleMap
            mapContainerStyle={containerStyle}
            center={center}
            zoom={12}
            options={{
                ...mapOptions,
                mapTypeId: 'roadmap',
            }}
            //   onLoad={map => (mapRef.current = map)}
        >
            {/* {Array.from(markers).map((marker, index) => (
        <Marker key={index} position={marker} />
      ))}
      {Array.from(polylines).map((polyline, index) => (
        <Polyline key={index} path={polyline} />
      ))}
      {showMyLocation && (
        <Marker
          position={center} // You can use geolocation API for real user position
          icon={{
            url: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png',
          }}
        />
      )} */}
        </GoogleMap>
    );
};

export default Map;
