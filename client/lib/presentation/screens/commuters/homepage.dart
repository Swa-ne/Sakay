import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
// import 'package:sakay_app/common/widgets/map.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/commuters/incident_report.dart';
import 'package:sakay_app/presentation/screens/commuters/performance_report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakay_app/presentation/screens/commuters/sos_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _initPreferences(); // FOR MAP STYLE PREFERENCE
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _checkFirstTime();
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
  Widget _buildTrafficLegend() {
    return Positioned(
      top: 123,
      left: 165,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (onClose != null) onClose(); // close manually
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
              _buildBusImage(imagePath),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBusInfo(
                      busNumber,
                      route,
                      distance,
                      estimatedTime,
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

  Widget _buildBusImage(String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF00A2FF),
      ),
      child: ClipRRect(
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                route,
                style: TextStyle(
                  fontSize: 10,
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
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    distance ?? "2 km",
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.watch_later_outlined,
                      color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    time ?? "5 mins",
                    style: const TextStyle(
                      fontSize: 10,
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

    return SizedBox(
      width: screenWidth,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(
                    width: 40,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Opacity(
                        opacity: 0,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints:
                              BoxConstraints(minWidth: 40, minHeight: 40),
                          icon: Icon(Icons.close, size: 20),
                          onPressed: null,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Map Preference",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 40, minHeight: 40),
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => _changeMapType(MapType.satellite),
                  child: _buildMapTypeCard(
                    MapType.satellite,
                    'Satellite',
                    'assets/satellite_map.png',
                  ),
                ),
                const SizedBox(width: 20),
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
            const SizedBox(height: 24),
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
                                  borderRadius: BorderRadius.circular(8)),
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
          // FOR MAP AND MAP STYLES
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _defaultCameraPosition,
              mapType: _currentMapType,
              myLocationEnabled: isTrackerOn,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: false,
              buildingsEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              minMaxZoomPreference: const MinMaxZoomPreference(10, 16),
              trafficEnabled: _showTraffic,
              onMapCreated: (controller) {
                _mapController = controller;
                if (!_mapInitialized) {
                  controller.setMapStyle(_getMapStyle());
                  _mapInitialized = true;
                  _restrictToPangasinan();
                }
              },
              onCameraMove: (position) {
                final zoom = position.zoom;
                if (zoom < 10 || zoom > 16) {
                  _mapController?.animateCamera(
                    CameraUpdate.zoomTo(zoom.clamp(10, 16).toDouble()),
                  );
                }
              },
            ),
          ),

          Positioned(
            top: 20,
            left: 16,
            right: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for a location...',
                            hintStyle: TextStyle(fontSize: 13),
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
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          final query = _searchController.text;
                          if (query.isNotEmpty) {
                            tracker.handleSearchAndRoute(query);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //       content: Text('Searching for "$query"...'))),
                            // );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (_isSearching && _searchResults.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final location = _searchResults[index];
                        return ListTile(
                          title: Text(location['name']),
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

          Positioned(
            top: 20,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      _showReportDialog(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.warning, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Map Preference Button
          Positioned(
            top: 75,
            left: 17,
            child: GestureDetector(
              onTap: () => _showMapPreferenceSheet(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.layers,
                  color: Color(0xFF4A90E2),
                  size: 22,
                ),
              ),
            ),
          ),

          // Bus List Button
          Positioned(
            top: 75,
            left: 65,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showBusList = !_showBusList;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus,
                        color: Color(0xFF00A2FF), size: 24),
                    SizedBox(width: 6),
                    Text(
                      "Bus List",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Stack(
            children: [
              // Your map or background widget here

              // Dimmed background + outside tap detector
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

              // Bus list container
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _showBusList ? 10 : -400,
                left: 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: _showBusList ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
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
                        ),
                        const SizedBox(height: 8),
                        _buildBusMenuItem(
                          context,
                          "002 - XYZ - 5678",
                          "Dagupan Terminal",
                          "assets/bus_image.png",
                          distance: "3.5 km",
                          estimatedTime: "8 mins",
                        ),
                        const SizedBox(height: 8),
                        _buildBusMenuItem(
                          context,
                          "003 - LMN - 9101",
                          "San Carlos City",
                          "assets/bus_image.png",
                          distance: "5 km",
                          estimatedTime: "12 mins",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Live Traffic Button
          Positioned(
            top: 75,
            left: 165,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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

          // Temporary Remove - SOS
          // Positioned(
          //   bottom: 90,
          //   right: 16,
          //   child: SizedBox(
          //     height: 50,
          //     width: 50,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         showDialog(
          //           context: context,
          //           barrierDismissible: false,
          //           builder: (context) => const SosOverlayDialog(),
          //         );
          //       },
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.red,
          //         padding: EdgeInsets.zero,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //       child: const FittedBox(
          //         fit: BoxFit.scaleDown,
          //         child: Text(
          //           'SOS',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Current Location (moves up smoothly if Bus List is visible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _showBusList ? 280 : 10, // animates smoothly
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
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
                        const Text(
                          'Phinma University of Pangasinan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '28WV+R2R, Arellano St, Downtown District',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
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
                      _trackerBloc.add(
                        isTrackerOn ? StopTrackMeEvent() : StartTrackMeEvent(),
                      );
                      setState(() {
                        isTrackerOn = !isTrackerOn;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isTrackerOn ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: (isTrackerOn ? Colors.red : Colors.blue)
                                .withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
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
