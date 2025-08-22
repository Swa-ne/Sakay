import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakay_app/common/widgets/map.dart';

class AdminMap extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminMap({super.key, required this.openDrawer});

  @override
  _AdminMapState createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  GoogleMapController? _mapController;
  late SharedPreferences _prefs;

  MapType _currentMapType = MapType.normal;
  bool _showTraffic = false;
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
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

  Widget _buildTrafficLegend() {
    return Positioned(
      top: 185,
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

          // Drawer button
          Positioned(
            top: 20,
            left: 15,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius:4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                onPressed: widget.openDrawer,
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 70,
            right: 20,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius:4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 2),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                ),
              ),
            ),
          ),

          // Map type selector
          Positioned(
            top: 75,
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
                offset: const Offset(55, 0),
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

          // Traffic toggle button
          Positioned(
            top: 130,
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
        ],
      ),
    );
  }
}
