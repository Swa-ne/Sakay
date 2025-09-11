import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';

class AdminMap extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminMap({super.key, required this.openDrawer});

  @override
  _AdminMapState createState() => _AdminMapState();
}

class _AdminMapState extends State<AdminMap> {
  late TrackerBloc _trackerBloc;
  bool isTrackerOn = false;

  MapType _currentMapType = MapType.normal;
  late SharedPreferences _prefs;
  bool _mapInitialized = false;
  GoogleMapController? _mapController;
  bool _showTraffic = false;

  bool _hasRestricted = false;

  void _toggleTraffic() {
    setState(() {
      _showTraffic = !_showTraffic;
    });
    _prefs.setBool('showTraffic', _showTraffic);

    if (_mapController != null) {
      _mapController!.setMapStyle(_showTraffic ? '' : _getMapStyle());
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  final CameraPosition _defaultCameraPosition = const CameraPosition(
    target: LatLng(16.0439, 120.3331),
    zoom: 14,
    bearing: 0,
    tilt: 0,
  );

  final LatLngBounds _pangasinanBounds = LatLngBounds(
    northeast: const LatLng(16.5, 120.8),
    southwest: const LatLng(15.5, 119.8),
  );

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentMapType = MapType.values[_prefs.getInt('mapType') ?? 0];
      _showTraffic = _prefs.getBool('showTraffic') ?? false;
    });
  }

  Future<void> _saveTrafficPreference(bool showTraffic) async {
    await _prefs.setBool('showTraffic', showTraffic);
  }

  void _changeMapType(MapType type) {
    setState(() {
      _currentMapType = type;
    });
    _prefs.setInt('mapType', type.index);
  }

  String _getMapStyle() {
    return '''
    [
      {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [ { "visibility": "off" } ]
      },
      {
        "featureType": "transit",
        "stylers": [ { "visibility": "off" } ]
      }
    ]
    ''';
  }

  // "Free flow"
  Widget _buildTrafficLegend(bool isDark) {
    return Positioned(
      top: 110,
      left: 60,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTrafficChip("Free", Colors.green, isDark),
            const SizedBox(width: 8),
            _buildTrafficChip("Moderate", Colors.orange, isDark),
            const SizedBox(width: 8),
            _buildTrafficChip("Heavy", Colors.red, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficChip(String text, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Future<void> _restrictToPangasinan() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_pangasinanBounds, 50),
      );
    }
  }

  Widget _buildMapTypeCard(MapType type, String label, String assetPath,
      {required bool isDark}) {
    final bool isSelected = _currentMapType == type;

    return InkWell(
      onTap: () {
        _changeMapType(type);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: const Color(0xFF4A90E2), width: 3)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetPath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreferenceContent(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(screenWidth * 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: screenWidth * 0.025,
              offset: Offset(0, -screenHeight * 0.003),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            SizedBox(
              height: screenHeight * 0.05,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Map Preference",
                        style: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: screenWidth * 0.05,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Map Type Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () => _changeMapType(MapType.normal),
                    child: _buildMapTypeCard(
                      MapType.normal,
                      'Default',
                      'assets/default_map.png',
                      isDark: isDark,
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () => _changeMapType(MapType.satellite),
                    child: _buildMapTypeCard(
                      MapType.satellite,
                      'Satellite',
                      'assets/satellite_map.png',
                      isDark: isDark,
                    ),
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () => _changeMapType(MapType.terrain),
                    child: _buildMapTypeCard(
                      MapType.terrain,
                      'Terrain',
                      'assets/terrain_map.png',
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),
          ],
        ),
      ),
    );
  }

  void _showMapPreferenceSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          padding: MediaQuery.of(context).viewInsets,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: Curves.easeOut,
            )),
            child: _buildMapPreferenceContent(context, isDark),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final s = sw / 375;
    final topButtonOffset = (65 * s).clamp(56.0, 95.0);
    final mapPrefLeft = (15 * s).clamp(12.0, sw - 60.0);
    final liveTrafficLeft = (60 * s).clamp(50.0, sw - 140.0);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _mapController!.setMapStyle(_getMapStyle());
                setState(() {
                  _mapInitialized = true;
                });
                if (_showTraffic) {
                  _mapController!.setMapStyle('');
                }
              },
              initialCameraPosition: _defaultCameraPosition,
              mapType: _currentMapType,
              trafficEnabled: _showTraffic,
              onCameraMove: (CameraPosition position) {
                if (!_hasRestricted) {
                  _restrictToPangasinan();
                  _hasRestricted = true;
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),

          // Drawer Button (responsive style)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.020,
            left: MediaQuery.of(context).size.width * 0.040,
            child: GestureDetector(
              onTap: widget.openDrawer,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.012,
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.025),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: MediaQuery.of(context).size.width * 0.02,
                      offset:
                          Offset(0, MediaQuery.of(context).size.height * 0.004),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : Colors.black,
                  size: MediaQuery.of(context).size.width *
                      0.06,
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.02,
            left: MediaQuery.of(context).size.width * 0.18,
            right: MediaQuery.of(context).size.width * 0.045,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.012,
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.025),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: MediaQuery.of(context).size.width * 0.02,
                    offset:
                        Offset(0, MediaQuery.of(context).size.height * 0.004),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: isDark ? Colors.white : Colors.grey,
                    size: MediaQuery.of(context).size.width * 0.06,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Map Preference Button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.040,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context, isDark),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.012,
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.025),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: MediaQuery.of(context).size.width * 0.02,
                      offset:
                          Offset(0, MediaQuery.of(context).size.height * 0.004),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.layers,
                  color: isDark ? Colors.white : const Color(0xFF00A2FF),
                  size: MediaQuery.of(context).size.width *
                      0.06, // responsive icon size
                ),
              ),
            ),
          ),

          // Live Traffic Button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.18,
            child: GestureDetector(
              onTap: _toggleTraffic,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.012,
                  horizontal: MediaQuery.of(context).size.width * 0.035,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: MediaQuery.of(context).size.width * 0.02,
                      offset:
                          Offset(0, MediaQuery.of(context).size.height * 0.003),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.traffic,
                      size: MediaQuery.of(context).size.width * 0.06,
                      color: isDark ? Colors.white : Colors.grey,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                    Text(
                      "Live Traffic",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_showTraffic) _buildTrafficLegend(isDark),
        ],
      ),
    );
  }
}
