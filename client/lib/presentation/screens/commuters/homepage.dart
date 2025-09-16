import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/commuters/incident_report.dart';
import 'package:sakay_app/presentation/screens/commuters/performance_report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakay_app/presentation/screens/commuters/sos_screen.dart'; // sos
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final Tracker tracker = Tracker();

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  late TrackerBloc _trackerBloc;
  OverlayEntry? _hintOverlay;
  bool _showInboxHint = true;
  bool _showAnnouncementsHint = false;
  bool _showProfileHint = false;
  bool isTrackerOn = false;

  bool _showBusList = false;
  bool _isBusListVisisble = false;

  void _toggleBusList() {
    setState(() {
      _isBusListVisisble = !_isBusListVisisble;
    });
  }

  void _closeBusList() {
    if (_isBusListVisisble) {
      setState(() {
        _isBusListVisisble = false;
      });
    }
  }

  // PARA DI MA ZOOM OUT MASYADO
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

  MapType _currentMapType = MapType.normal;
  late SharedPreferences _prefs;
  bool _mapInitialized = false;
  GoogleMapController? _mapController;
  bool _showTraffic = false;
  LatLng? _currentLocation;
  String _nearestDestination = "Turn on location";
  late Timer _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initPreferences(); // FOR MAP STYLE PREFERENCE
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _checkFirstTime();
    _setupLocationListener();
  }

  @override
  void dispose() {
    _locationUpdateTimer.cancel();
    super.dispose();
  }

  void _setupLocationListener() {
    // Set up a periodic timer to update the nearest destination
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (isTrackerOn) {
        try {
          Location position = await tracker.getLocationandSpeed();
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
            _nearestDestination = tracker.getNearestDestination(
                position.latitude, position.longitude);
          });
        } catch (e) {
          print("Error getting location: $e");
        }
      }
    });
  }

  // PARA SA SHARED PREFERENCES NG MAP STYLE AND LIVE TRAFFIC
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

  // PARA SA LIVE TRAFFIC
  // LIST
  // "Free flow"
  Widget _buildTrafficLegend(double s, double sw) {
    // s = scale factor for sizing, sw = screen width
    final left = sw * 0.40; // keeps relative position across sizes
    final top = s * 123;
    return Positioned(
      top: top,
      left: left.clamp(12.0, sw - 12.0 - (220 * s / 16)), // keep inside screen
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: s * 12, vertical: s * 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(s * 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: s * 6,
              offset: Offset(0, s * 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTrafficChip("Free", Colors.green, s),
            SizedBox(width: s * 8),
            _buildTrafficChip("Light", Colors.orange, s),
            SizedBox(width: s * 8),
            _buildTrafficChip("Heavy", Colors.red, s),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficChip(String text, Color color, double s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: s * 10,
          height: s * 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: s * 4),
        Text(
          text,
          style: TextStyle(
            fontSize: s * 11,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Bus List Container
  Widget _buildBusMenuItem(
    BuildContext context,
    String busNumber,
    String route,
    String imagePath, {
    String? distance,
    String? estimatedTime,
    VoidCallback? onClose,
  }) {
    final sw = MediaQuery.of(context).size.width;
    final s = sw / 375;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12 * s),
        onTap: () {
          if (onClose != null) onClose(); // close manually
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12 * s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12 * s),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusImage(imagePath, s),
              SizedBox(width: 16 * s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBusInfo(
                      busNumber,
                      route,
                      distance,
                      estimatedTime,
                      s,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusImage(String imagePath, double s) {
    return Container(
      width: 50 * s,
      height: 50 * s,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * s),
        color: const Color(0xFF00A2FF),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8 * s),
        child: Image.asset(
          'assets/bus.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBusInfo(
    String busNumber,
    String route,
    String? distance,
    String? time,
    double s,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                busNumber,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11 * s,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4 * s),
              Text(
                route,
                style: TextStyle(
                  fontSize: 10 * s,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.green.shade600,
                    size: 16 * s,
                  ),
                  SizedBox(width: 4 * s),
                  Text(
                    distance ?? "2 km",
                    style: TextStyle(
                      fontSize: 9 * s,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4 * s),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.watch_later_outlined,
                      color: Colors.blue, size: 16 * s),
                  SizedBox(width: 4 * s),
                  Text(
                    time ?? "5 mins",
                    style: TextStyle(
                      fontSize: 10 * s,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
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

  Future<void> _checkFirstTime() async {
    String isFirstTime = await _tokenController.getFirstTime();
    if (isFirstTime.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_showInboxHint) {
          _showHint(
            title: "Inbox",
            icon: Icons.inbox,
            message:
                "The inbox is where you can find your chats, messages, and other communication means within the application",
            onDismiss: _dismissInboxHint,
          );
        }
      });
    }
  }

  void _dismissInboxHint() {
    _hintOverlay?.remove();
    setState(() {
      _showInboxHint = false;
      _showAnnouncementsHint = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_showAnnouncementsHint) {
        _showHint(
          title: "Announcements",
          icon: Icons.campaign,
          message:
              "In the announcements tab, it will provide you with everything you need to be aware of such as alerts and warnings to make sure you know what is happening",
          onDismiss: _dismissAnnouncementsHint,
        );
      }
    });
  }

  void _dismissAnnouncementsHint() {
    _hintOverlay?.remove();
    setState(() {
      _showAnnouncementsHint = false;
      _showProfileHint = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_showProfileHint) {
        _showHint(
          title: "Profile",
          icon: Icons.person,
          message:
              "The profile tab will allow you to customize your preferences, see your privileges within the application, and provide you with other options for a better, tailored performance",
          onDismiss: _dismissProfileHint,
        );
      }
    });
  }

  void _dismissProfileHint() {
    _hintOverlay?.remove();
    _tokenController.updateFirstTime("yes");
    setState(() {
      _showProfileHint = false;
    });
  }

  void _showHint({
    required String title,
    required IconData icon,
    required String message,
    required VoidCallback onDismiss,
  }) {
    final overlay = Overlay.of(context);
    final Size screenSize = MediaQuery.of(context).size;
    double targetX = 0;
    double bottomPosition = 80; // Default position
    bool isProfileHint = title == "Profile";
    if (title == "Inbox") {
      targetX = screenSize.width * 0.14 + 23;
    } else if (title == "Announcements") {
      targetX = screenSize.width * 0.39 + 22;
    } else if (isProfileHint) {
      targetX = screenSize.width * 0.80; // Adjust to right for Profile
    }
    _hintOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dark overlay background
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),
          // Hint Box
          Positioned(
            bottom: bottomPosition - 10, // Adjusted to align above the icon
            left: isProfileHint
                ? targetX - 200
                : targetX -
                    60, // Move left for Profile to keep it inside screen
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  // Hint box
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: 260,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onDismiss,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text('Got it',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow - Adjusted for Profile Hint
                  Align(
                    alignment: isProfileHint
                        ? Alignment.bottomRight
                        : Alignment.center,
                    child: Padding(
                      padding: isProfileHint
                          ? const EdgeInsets.only(left: 200)
                          : EdgeInsets.zero,
                      child: ClipPath(
                        clipper: ArrowClipper(isProfileHint: isProfileHint),
                        child: Container(
                          width: 20,
                          height: 12,
                          color: Colors.white,
                        ),
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
    overlay.insert(_hintOverlay!);
  }

  // PARA DI LANG LUMAYO MASYADO SA ZOOM
  Future<void> _restrictToPangasinan() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(_pangasinanBounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final s = sw / 375; // base scale using 375 as reference width

    // responsive paddings and positions derived from screen width
    final topButtonOffset = (75 * s).clamp(56.0, 95.0);
    final mapPrefLeft = (17 * s).clamp(12.0, sw - 60.0);
    final busListLeft = (63 * s).clamp(48.0, sw - 120.0);
    final liveTrafficLeft = (150 * s).clamp(110.0, sw - 140.0);

    return Scaffold(
        body: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_showBusList) {
          setState(() {
            _showBusList = false;
          });
        }
      },
      child: Stack(
        children: [
          // FOR MAP AND MAP STYLES - Pass mapType and showTraffic
          Positioned.fill(
            child: MyMapWidget(
              mapType: _currentMapType,
              showTraffic: _showTraffic,
            ),
          ),

          // Top search + suggestions area (responsive)
          Positioned(
            top: 20 * s,
            left: 16 * s,
            right: 70 * s,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 * s),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8 * s),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5 * s,
                        offset: Offset(0, 2 * s),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 20 * s),
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(fontSize: 13 * s),
                          decoration: InputDecoration(
                            hintText: 'Search for a location...',
                            hintStyle: TextStyle(fontSize: 13 * s),
                            border: InputBorder.none,
                          ),
                          onChanged: (query) async {
                            if (query.isNotEmpty) {
                              var result = await tracker.searchLocations(query);
                              setState(() {
                                _searchResults = result;
                                _isSearching = true;
                              });
                            } else {
                              setState(() {
                                _searchResults = [];
                                _isSearching = false;
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.send, color: Colors.black, size: 20 * s),
                        onPressed: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            tracker.handleSearchAndRoute(query);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8 * s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8 * s),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5 * s,
                          offset: Offset(0, 2 * s),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        return ListTile(
                          title: Text(location['name'],
                              style: TextStyle(fontSize: 13 * s)),
                          onTap: () {
                            _searchController.text = location['name'];
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // Top right report button
          Positioned(
            top: 20 * s,
            right: 16 * s,
            child: Container(
              padding: EdgeInsets.all(2.3 * s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8 * s),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5 * s,
                    offset: Offset(0, 2 * s),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8 * s),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      _showReportDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12.0 * s),
                      child:
                          Icon(Icons.warning, color: Colors.red, size: 20 * s),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Map Preference Button (responsive placed)
          Positioned(
            top: topButtonOffset,
            left: mapPrefLeft,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context),
              child: Container(
                padding: EdgeInsets.all(8 * s),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  color: const Color(0xFF4A90E2),
                  size: 22 * s,
                ),
              ),
            ),
          ),

          // Bus List Button
          Positioned(
            top: topButtonOffset,
            left: busListLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showBusList = !_showBusList;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8 * s),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Icon(Icons.directions_bus,
                        color: const Color(0xFF00A2FF), size: 22 * s),
                    SizedBox(width: 6 * s),
                    Text(
                      "Bus List",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11 * s,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bus list overlay & container (responsive width)
          Stack(
            children: [
              if (_showBusList)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showBusList = false; // close bus list
                      });
                    },
                    child: Container(
                      color: Colors.transparent, // transparent overlay
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _showBusList ? 10 * s : -400 * s,
                left: 16 * s,
                right: 16 * s,
                child: AnimatedOpacity(
                  opacity: _showBusList ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(12 * s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12 * s),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8 * s,
                          offset: Offset(0, 3 * s),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height *
                          .32, // half the screen
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildBusMenuItem(
                              context,
                              "001 - ABC - 1234",
                              "Boundary Marker Lingayen",
                              "assets/bus_image.png",
                              distance: "2 km",
                              estimatedTime: "5 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                            _buildBusMenuItem(
                              context,
                              "002 - XYZ - 5678",
                              "Dagupan Terminal",
                              "assets/bus_image.png",
                              distance: "3.5 km",
                              estimatedTime: "8 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                            _buildBusMenuItem(
                              context,
                              "003 - LMN - 9101",
                              "San Carlos City",
                              "assets/bus_image.png",
                              distance: "5 km",
                              estimatedTime: "12 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                            _buildBusMenuItem(
                              context,
                              "004 - ABC - 1234",
                              "Boundary Marker Lingayen",
                              "assets/bus_image.png",
                              distance: "2 km",
                              estimatedTime: "5 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                            _buildBusMenuItem(
                              context,
                              "005 - XYZ - 5678",
                              "Dagupan Terminal",
                              "assets/bus_image.png",
                              distance: "3.5 km",
                              estimatedTime: "8 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                            _buildBusMenuItem(
                              context,
                              "006 - LMN - 9101",
                              "San Carlos City",
                              "assets/bus_image.png",
                              distance: "5 km",
                              estimatedTime: "12 mins",
                              onClose: () {
                                setState(() {
                                  _showBusList = false;
                                });
                              },
                            ),
                            SizedBox(height: 8 * s),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          // Live Traffic Button (responsive placed)
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
                padding: EdgeInsets.all(8 * s),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Show the traffic legend if live traffic is enabled
          if (_showTraffic) _buildTrafficLegend(s, sw),

          // Current Location (moves up smoothly if Bus List is visible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showBusList ? 280 * s : 10 * s, // animates smoothly
            left: 16 * s,
            right: 16 * s,
            child: Container(
              padding: EdgeInsets.all(16 * s),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * s),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8 * s,
                    offset: Offset(0, 3 * s),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8 * s),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8 * s),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 20 * s,
                    ),
                  ),
                  SizedBox(width: 12 * s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isTrackerOn
                              ? _nearestDestination
                              : "Turn on location",
                          style: TextStyle(
                            fontSize: 12 * s,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          isTrackerOn
                              ? '' // TODO: real
                              : "Turn on your tracker to let drivers know your location",
                          style: TextStyle(
                            fontSize: 10 * s,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12 * s),
                  InkWell(
                    onTap: () async {
                      _trackerBloc.add(
                        isTrackerOn ? StopTrackMeEvent() : StartTrackMeEvent(),
                      );
                      setState(() {
                        isTrackerOn = !isTrackerOn;
                      });

                      // Update destination immediately when turning on tracker
                      if (!isTrackerOn) {
                        // This will flip to true after the toggle
                        try {
                          Location position =
                              await tracker.getLocationandSpeed();
                          setState(() {
                            _currentLocation =
                                LatLng(position.latitude, position.longitude);
                            _nearestDestination = tracker.getNearestDestination(
                                position.latitude, position.longitude);
                          });
                        } catch (e) {
                          print("Error getting location: $e");
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(8 * s),
                    child: Container(
                      width: 40 * s,
                      height: 40 * s,
                      decoration: BoxDecoration(
                        color: isTrackerOn ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(8 * s),
                        boxShadow: [
                          BoxShadow(
                            color: (isTrackerOn ? Colors.red : Colors.blue)
                                .withOpacity(0.3),
                            blurRadius: 4 * s,
                            offset: Offset(0, 2 * s),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: Colors.white,
                        size: 20 * s,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Stack(
            children: [
              Positioned(
                top: 20 * s,
                left: 16 * s,
                right: 70 * s,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12 * s),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8 * s),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5 * s,
                        offset: Offset(0, 2 * s),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 20 * s),
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          cursorColor: const Color(0xFF00A2FF),
                          style: TextStyle(fontSize: 15 * s),
                          decoration: InputDecoration(
                            hintText: 'Search for a location...',
                            hintStyle: TextStyle(fontSize: 13 * s),
                            border: InputBorder.none,
                          ),
                          onChanged: (query) async {
                            if (query.isNotEmpty) {
                              var result = await tracker.searchLocations(query);
                              setState(() {
                                _searchResults = result;
                                _isSearching = true;
                              });
                            } else {
                              setState(() {
                                _searchResults = [];
                                _isSearching = false;
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send,
                            color: Colors.transparent, size: 20 * s),
                        onPressed: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            tracker.handleSearchAndRoute(query);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_isSearching && _searchResults.isNotEmpty) ...[
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = false;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: (25 * s) + (50 * s),
                  left: 16 * s,
                  right: 16 * s,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 530 * s),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8 * s),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5 * s,
                          offset: Offset(0, 2 * s),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        return ListTile(
                          visualDensity: const VisualDensity(horizontal: -4),
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 18 * s,
                          ),
                          title: Text(
                            location['name'],
                            style: TextStyle(fontSize: 15 * s),
                          ),
                          onTap: () {
                            _searchController.text = location['name'];
                            setState(() {
                              _isSearching = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    ));
  }
}

class ArrowClipper extends CustomClipper<Path> {
  final bool isProfileHint;
  ArrowClipper({required this.isProfileHint});
  @override
  Path getClip(Size size) {
    Path path = Path();
    if (isProfileHint) {
      path.moveTo(size.width - 20, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 10, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0); // Top-right
      path.lineTo(size.width / 2, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void _showReportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF00A2FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  "Reports",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      SizedBox(width: 8),
                      Text(
                        "Select an option",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IncidentReportPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.directions_car, color: Colors.black),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Incident Report",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Send reports about events occurred",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PerformanceReportPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.sticky_note_2, color: Colors.black),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Performance Report",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Analyze key metrics and evaluate progress",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
