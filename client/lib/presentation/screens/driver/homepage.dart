import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/bloc/tracker/tracker_state.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
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

    if (_mapController != null && mounted) {
      _mapController!.setMapStyle(_getMapStyle());
    }
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

// "Free flow"
  Widget _buildTrafficLegend() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 88,
      left: 183,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.grey[850] : Colors.white,
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
            _buildTrafficChip("Light", Colors.orange, isDark),
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

  void _showMapPreferenceSheet(BuildContext context) {
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
            child: _buildMapPreferenceContent(context),
          ),
        );
      },
    );
  }

  Widget _buildMapPreferenceContent(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final sw = MediaQuery.of(context).size.width;
    final s = sw / 375;

    // responsive paddings and positions derived from screen width
    final bottomButtonOffset = (83 * s).clamp(56.0, 95.0);
    final mapPrefLeft = (17 * s).clamp(12.0, sw - 60.0);
    final liveTrafficLeft = (63 * s).clamp(12.0, sw - 140.0);

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
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.location_on,
                          color: Colors.black, size: 20),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Phinma University of Pangasinan',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
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
                    onTap: () async {
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

          // Map Preference Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.11,
            left: MediaQuery.of(context).size.width * 0.045,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context),
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
                      0.06,
                ),
              ),
            ),
          ),

          // Live Traffic Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.11,
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

          if (_showTraffic) _buildTrafficLegend(),

          // Location and Tracker Button
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16 * s),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white,
                borderRadius: BorderRadius.circular(12 * s),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      Theme.of(context).brightness == Brightness.dark
                          ? 0.4
                          : 0.1,
                    ),
                    blurRadius: 8 * s,
                    offset: Offset(0, 3 * s),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Phinma University of Pangasinan',
                          style: TextStyle(
                            fontSize: 12 * s,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '28WV+R2R, Arellano St, Downtown District',
                          style: TextStyle(
                            fontSize: 10 * s,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
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
