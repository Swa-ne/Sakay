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
  Widget _buildTrafficLegend() {
    return Positioned(
      top: 110,
      left: 60,
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
            _buildTrafficChip("Moderate", Colors.orange),
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

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final s = sw / 375; // base scale using 375 as reference width

    final topButtonOffset = (65 * s).clamp(56.0, 95.0);
    final mapPrefLeft = (15 * s).clamp(12.0, sw - 60.0);
    final liveTrafficLeft = (60 * s).clamp(50.0, sw - 140.0);

    return Scaffold(
      body: Stack(
        children: [
          // Updated to pass mapType and showTraffic parameters
          Positioned.fill(
            child: MyMapWidget(
              mapType: _currentMapType,
              showTraffic: _showTraffic,
            ),
          ),

          // Drawer
          Positioned(
            top: 20,
            left: 15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                    onPressed: widget.openDrawer,
                  );
                },
              ),
            ),
          ),

          // Search Bar
          Positioned(
            top: 20,
            left: 60,
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
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 2),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                ),
              ),
            ),
          ),

          // Map Preference Button
          Positioned(
            top: topButtonOffset,
            left: mapPrefLeft,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context),
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.layers, color: Color(0xFF4A90E2), size: 22),
                  ],
                ),
              ),
            ),
          ),

          // Live Traffic Button - Updated to only change state
          Positioned(
            top: topButtonOffset,
            left: liveTrafficLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTraffic = !_showTraffic;
                  _saveTrafficPreference(_showTraffic);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                      child: const Icon(
                        Icons.traffic,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Live Traffic",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showTraffic) _buildTrafficLegend(),
        ],
      ),
    );
  }
}