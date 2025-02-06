import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationToDestination(),
    );
  }
}

class LocationToDestination extends StatefulWidget {
  const LocationToDestination({super.key});

  @override
  _LocationToDestinationState createState() => _LocationToDestinationState();
}

class _LocationToDestinationState extends State<LocationToDestination> {
  late GoogleMapController mapController;

  // Initial location of the map camera.
  final LatLng _initialPosition =
      const LatLng(16.0445, 120.3333); // Example coordinates for Dagupan
  final LatLng _destination =
      const LatLng(16.0439, 120.3406); // Example coordinates for Harbour McDo

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    _setMarkers();
  }

  void _setMarkers() {
    _markers.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: _initialPosition,
      infoWindow: const InfoWindow(title: 'Current Location'),
    ));
    _markers.add(Marker(
      markerId: const MarkerId('destination'),
      position: _destination,
      infoWindow: const InfoWindow(title: 'Destination'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location to Destination'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Location:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('5045 P Burgos'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Destination:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Harbour McDo'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle confirmation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
