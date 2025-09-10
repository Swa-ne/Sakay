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
          color: Colors.white,
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
            _buildTrafficChip("Free", Colors.green),
            const SizedBox(width: 8),
            _buildTrafficChip("light", Colors.orange),
            const SizedBox(width: 8),
            _buildTrafficChip("Heavy", Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficChip(String text, Color color) {
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
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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

  Widget _buildMapTypeCard(MapType type, String label, String assetPath) {
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
    final s = screenWidth / 375;
    return SizedBox(
      width: screenWidth,
      child: Container(
        padding: EdgeInsets.fromLTRB(16 * s, 16 * s, 16 * s, 24 * s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16 * s)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10 * s,
              offset: Offset(0, -2 * s),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40 * s,
              child: Row(
                children: [
                  SizedBox(
                    width: 40 * s,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                              minWidth: 40 * s, minHeight: 40 * s),
                          icon: Icon(Icons.close, size: 20 * s),
                          onPressed: null,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Map Preference",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14 * s,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40 * s,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          BoxConstraints(minWidth: 40 * s, minHeight: 40 * s),
                      icon: Icon(Icons.close, size: 20 * s),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16 * s),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _changeMapType(MapType.normal),
                  child: _buildMapTypeCard(
                    MapType.normal,
                    'Default',
                    'assets/default_map.png',
                  ),
                ),
                SizedBox(width: 20 * s),
                InkWell(
                  onTap: () => _changeMapType(MapType.satellite),
                  child: _buildMapTypeCard(
                    MapType.satellite,
                    'Satellite',
                    'assets/satellite_map.png',
                  ),
                ),
                SizedBox(width: 20 * s),
                InkWell(
                  onTap: () => _changeMapType(MapType.terrain),
                  child: _buildMapTypeCard(
                    MapType.terrain,
                    'Terrain',
                    'assets/terrain_map.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24 * s),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final s = sw / 375;

    // responsive paddings and positions derived from screen width
    final bottomButtonOffset = (83 * s).clamp(56.0, 95.0);
    final mapPrefLeft = (17 * s).clamp(12.0, sw - 60.0);
    final liveTrafficLeft = (63 * s).clamp(12.0, sw - 140.0);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: MyMapWidget(),
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
            bottom: bottomButtonOffset,
            left: mapPrefLeft,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context),
              child: Container(
                padding: EdgeInsets.all(8 * s),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10 * s),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8 * s,
                      offset: Offset(0, 3 * s),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.layers,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF00A2FF),
                  size: 22 * s,
                ),
              ),
            ),
          ),

          // Live Traffic Button
          Positioned(
            bottom: bottomButtonOffset,
            left: liveTrafficLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTraffic = !_showTraffic;
                  _saveTrafficPreference(_showTraffic);
                  if (_mapController != null) {
                    _mapController!
                        .setMapStyle(_showTraffic ? '' : _getMapStyle());
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(8 * s),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12 * s),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8 * s,
                      offset: Offset(0, 3 * s),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 112, 112, 112),
                          Color.fromARGB(255, 204, 204, 204)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Icon(
                        Icons.traffic,
                        size: 22 * s,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6 * s),
                    Text(
                      "Live Traffic",
                      style: TextStyle(
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.grey,
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
