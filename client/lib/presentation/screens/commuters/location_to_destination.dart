import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationToDestination(),
    );
  }
}

class LocationToDestination extends StatefulWidget {
  @override
  _LocationToDestinationState createState() => _LocationToDestinationState();
}

class _LocationToDestinationState extends State<LocationToDestination> {
  late GoogleMapController mapController;

  // Initial location of the map camera.
  final LatLng _initialPosition =
      LatLng(16.0445, 120.3333); // Example coordinates for Dagupan
  final LatLng _destination =
      LatLng(16.0439, 120.3406); // Example coordinates for Harbour McDo

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  late PolylinePoints _polylinePoints;

  final String _googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  @override
  void initState() {
    super.initState();
    _polylinePoints = PolylinePoints();

    _setMarkers();
    _setPolyline();
  }

  void _setMarkers() {
    _markers.add(Marker(
      markerId: MarkerId('currentLocation'),
      position: _initialPosition,
      infoWindow: InfoWindow(title: 'Current Location'),
    ));
    _markers.add(Marker(
      markerId: MarkerId('destination'),
      position: _destination,
      infoWindow: InfoWindow(title: 'Destination'),
    ));
  }

  void _setPolyline() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      _googleApiKey,
      PointLatLng(_initialPosition.latitude, _initialPosition.longitude),
      PointLatLng(_destination.latitude, _destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: _polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location to Destination'),
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Location:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('5045 P Burgos'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Destination:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Harbour McDo'),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle confirmation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Confirm'),
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
