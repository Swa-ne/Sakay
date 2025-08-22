import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  late TrackerBloc _trackerBloc;
  bool isTrackerOn = false;

  GoogleMapController? _mapController;
  late SharedPreferences _prefs;

  MapType _currentMapType = MapType.normal;
  bool _showTraffic = false;
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentMapType = MapType.values[_prefs.getInt('mapType') ?? 0];
      _showTraffic = _prefs.getBool('showTraffic') ?? false;
    });
  }

  void _changeMapType(MapType type) {
    setState(() {
      _currentMapType = type;
    });
    _prefs.setInt('mapType', type.index);
  }

  Future<void> _saveTrafficPreference(bool showTraffic) async {
    await _prefs.setBool('showTraffic', showTraffic);
  }

  String _getMapStyle() {
    return '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [
          { "visibility": "off" }
        ]
      },
      {
        "featureType": "transit",
        "stylers": [
          { "visibility": "off" }
        ]
      }
    ]
    ''';
  }

  Widget _buildTrafficLegend() {
    return Positioned(
      bottom: 185,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTrafficLegendItem("Free flow", Colors.green),
            _buildTrafficLegendItem("Moderate", Colors.orange),
            _buildTrafficLegendItem("Heavy", Colors.red),
            _buildTrafficLegendItem("Standstill", Colors.red.shade900),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<MapType> _buildMapTypeItem(
      MapType type, String label, String imagePath) {
    return PopupMenuItem<MapType>(
      value: type,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  _currentMapType == type ? FontWeight.bold : FontWeight.normal,
              color: _currentMapType == type ? Colors.blue : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _currentMapType == type
                    ? Colors.blue
                    : Colors.grey.shade300,
                width: _currentMapType == type ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: const CameraPosition(
              target: LatLng(16.0439, 120.3331),
              zoom: 14,
            ),
            trafficEnabled: _showTraffic,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
              if (!_mapInitialized) {
                controller.setMapStyle(_getMapStyle());
                _mapInitialized = true;
              }
            },
          ),

          // 🔹 Map type selector
          Positioned(
            bottom: 75,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: PopupMenuButton<MapType>(
                icon: const Icon(Icons.layers, color: Colors.blue, size: 22),
                onSelected: _changeMapType,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(55, -50),
                constraints: const BoxConstraints(minWidth: 0, maxWidth: 300),
                itemBuilder: (context) => [
                  PopupMenuItem<MapType>(
                    enabled: false,
                    child: Material(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _changeMapType(MapType.normal),
                            child: _buildMapTypeItem(
                              MapType.normal,
                              'Default',
                              'assets/default_map.png',
                            ).child,
                          ),
                          GestureDetector(
                            onTap: () => _changeMapType(MapType.satellite),
                            child: _buildMapTypeItem(
                              MapType.satellite,
                              'Satellite',
                              'assets/satellite_map.png',
                            ).child,
                          ),
                          GestureDetector(
                            onTap: () => _changeMapType(MapType.terrain),
                            child: _buildMapTypeItem(
                              MapType.terrain,
                              'Terrain',
                              'assets/terrain_map.png',
                            ).child,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Traffic toggle button
          Positioned(
            bottom: 128,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.traffic,
                  color: _showTraffic ? Colors.blue : Colors.grey.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _showTraffic = !_showTraffic;
                    _saveTrafficPreference(_showTraffic);
                    if (_mapController != null) {
                      _mapController!
                          .setMapStyle(_showTraffic ? '' : _getMapStyle());
                    }
                  });
                },
                tooltip: 'Toggle Traffic',
              ),
            ),
          ),

          if (_showTraffic) _buildTrafficLegend(),

          // 🔹 Bottom tracker controls
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Icon(Icons.location_on,
                        color: Colors.black, size: 20),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phinma University of Pangasinan',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '28WV+R2R, Arellano St, Downtown District',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      _trackerBloc.add(isTrackerOn
                          ? StopTrackMyVehicleEvent()
                          : StartTrackMyVehicleEvent());
                      setState(() {
                        isTrackerOn = !isTrackerOn;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: isTrackerOn
                            ? const Color(0xFFFF0000)
                            : const Color(0xFF00A1F8),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Icon(
                        Icons.drive_eta,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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
