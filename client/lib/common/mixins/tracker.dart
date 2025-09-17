import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:sakay_app/data/constant/allowed_points.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:vibration/vibration.dart';

final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

class Tracker {
  static final Tracker _instance = Tracker._internal();
  factory Tracker() => _instance;

  Tracker._internal();

  final TokenControllerImpl _tokenController = TokenControllerImpl();

  StreamSubscription<geolocator.Position>? positionStream;
  GoogleMapController? googleMapController;
  Map<String, Marker> busses = HashMap();
  Map<String, Marker> people = HashMap();
  Set<Polyline> polylines = {};

  ValueNotifier<Set<Marker>> markersNotifier = ValueNotifier(<Marker>{});
  ValueNotifier<Set<Polyline>> polylineNotifier = ValueNotifier(<Polyline>{});

  Uint8List? carImageData;
  Uint8List? personImageData;
  ValueNotifier<bool> showMyLocationBool = ValueNotifier(false);

  final Color _routeColor = Color(0xFF4285F4); // Google Blue
  final Color _passedRouteColor = Color(0xFFAECBFA); // Light Google Blue
  final int _routeWidth = 6;
  final int _passedRouteWidth = 4;

  Map<String, dynamic>? _currentRoute;
  LatLng? _lastPosition;
  List<LatLng> _passedPoints = [];

  ValueNotifier<bool> isNearDestination = ValueNotifier(false);
  Timer? _destinationCheckTimer;
  bool _alarmActive = false;
  bool _alarmDisabled = false;
  bool _alarmTriggeredForCurrentDestination = false;
  LatLng? _currentDestination;

  Function(String)? _showDestinationApproachingCallback;
  Function(String)? _showAlreadyAtDestinationCallback;

  int _vibrationLevel = 3;

  void setVibrationLevel(int level) {
    _vibrationLevel = level.clamp(1, 5);
    print("Vibration level set to: $_vibrationLevel");
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // radius of Earth in meters
    double toRad(double value) => value * pi / 180;

    final phi1 = toRad(lat1);
    final phi2 = toRad(lat2);
    final deltaPhi = toRad(lat2 - lat1);
    final deltaLambda = toRad(lon2 - lon1);

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  String getNearestDestination(double lat, double lng) {
    var nearest = allowedDestinations[0];
    var minDistance = haversineDistance(
      lat,
      lng,
      nearest["lat"],
      nearest["lng"],
    );

    for (var point in allowedDestinations) {
      final dist = haversineDistance(lat, lng, point["lat"], point["lng"]);
      if (dist < minDistance) {
        minDistance = dist;
        nearest = point;
      }
    }

    // If the nearest distance is more than 2km, return "Too far"
    if (minDistance > 2000) {
      return "Too far";
    }

    return nearest["name"];
  }

  void startTracking(LatLng destination) {
    _checkInitialDistance(destination).then((isWithin2km) {
      if (isWithin2km) {
        print(
            "Destination is already within 2km, alarm disabled but tracking enabled");
        _alarmDisabled = true;
      } else {
        _alarmDisabled = false;
      }

      positionStream = geolocator.Geolocator.getPositionStream(
        locationSettings: const geolocator.LocationSettings(
          accuracy: geolocator.LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((geolocator.Position position) async {
        LatLng currentLocation = LatLng(position.latitude, position.longitude);

        _updateRouteProgress(currentLocation);

        // Check distance to destination (alarm will be skipped if disabled)
        _checkDistanceToDestination(currentLocation, destination);

        double distanceToLine = _getDistanceToPolyline(currentLocation);

        if (distanceToLine > 50) {
          print("User deviated from route. Recalculating...");
          await getRouteAndETA(currentLocation, destination);
        }
      });

      // Start periodic destination checking
      _startDestinationChecking(destination);
    });
  }

  void stopTracking() {
    positionStream?.cancel();
    positionStream = null;
    _destinationCheckTimer?.cancel();
    _destinationCheckTimer = null;
    _stopAlarm();
    _currentRoute = null;
    _passedPoints.clear();
    _alarmTriggeredForCurrentDestination = false;
    _alarmDisabled = false;

    // Clear all polylines and notify listeners
    polylines.clear();
    polylineNotifier.value = polylines;

    // Also clear the destination marker
    markersNotifier.value
        .removeWhere((marker) => marker.markerId.value == 'destination');
    markersNotifier.notifyListeners();
  }

  void _startDestinationChecking(LatLng destination) {
    _destinationCheckTimer?.cancel();
    _destinationCheckTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        Location currentLocation = await getLocationandSpeed();
        LatLng currentLatLng =
            LatLng(currentLocation.latitude, currentLocation.longitude);

        _checkDistanceToDestination(currentLatLng, destination);
      } catch (e) {
        print('Error checking destination distance: $e');
      }
    });
  }

  Future<bool> _checkInitialDistance(LatLng destination) async {
    try {
      Location currentLocation = await getLocationandSpeed();
      LatLng currentLatLng =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      double initialDistance = geolocator.Geolocator.distanceBetween(
        currentLatLng.latitude,
        currentLatLng.longitude,
        destination.latitude,
        destination.longitude,
      );

      return initialDistance <= 2000; // Return true if already within 2km
    } catch (e) {
      print('Error checking initial distance: $e');
      return false; // If we can't check, allow alarms to work
    }
  }

  void _checkDistanceToDestination(LatLng currentLocation, LatLng destination) {
    double distance = geolocator.Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    if (distance <= 100 && _showAlreadyAtDestinationCallback != null) {
      String destinationName =
          _currentRoute?['destinationName'] ?? 'your destination';
      _showAlreadyAtDestinationCallback!(destinationName);
    }
    bool isNear = distance <= 2000;

    if (_currentDestination != destination) {
      _currentDestination = destination;
      _alarmTriggeredForCurrentDestination = false;
    }

    if (isNear &&
        !_alarmActive &&
        !_alarmTriggeredForCurrentDestination &&
        !_alarmDisabled) {
      _triggerDestinationAlarm();
      _alarmTriggeredForCurrentDestination = true;
    } else if (!isNear && _alarmActive) {
      _stopAlarm();
      _alarmTriggeredForCurrentDestination = false;
    }

    isNearDestination.value = isNear;
  }

  void setDestinationApproachingCallback(Function(String) callback) {
    _showDestinationApproachingCallback = callback;
  }

  void setAlreadyAtDestinationCallback(Function(String) callback) {
    _showAlreadyAtDestinationCallback = callback;
  }

  void _triggerDestinationAlarm() async {
    _alarmActive = true;

    if (await Vibration.hasVibrator() ?? false) {
      _startVibrationPattern();
    }

    if (_showDestinationApproachingCallback != null && _currentRoute != null) {
      String destinationName = _currentRoute?["destination"];
      _showDestinationApproachingCallback!(destinationName);
    }
  }

  void _startVibrationPattern() {
    switch (_vibrationLevel) {
      case 1:
        Vibration.vibrate(
          pattern: [200, 800],
          repeat: -1,
        );
        break;
      case 2:
        Vibration.vibrate(
          pattern: [300, 700],
          repeat: -1,
        );
        break;
      case 3:
        Vibration.vibrate(
          pattern: [500, 1000],
          repeat: -1,
        );
        break;
      case 4:
        Vibration.vibrate(
          pattern: [700, 500],
          repeat: -1,
        );
        break;
      case 5:
        Vibration.vibrate(
          pattern: [1000, 300],
          repeat: -1,
        );
        break;
      default:
        Vibration.vibrate(
          pattern: [500, 1000],
          repeat: -1,
        );
    }
  }

  void _stopAlarm() {
    _alarmActive = false;
    Vibration.cancel();
    isNearDestination.value = false;
  }

  double _getDistanceToPolyline(LatLng currentLocation) {
    double minDistance = double.infinity;

    if (_currentRoute == null || _currentRoute!['points'] == null) {
      return minDistance;
    }

    List<LatLng> routePoints = List<LatLng>.from(_currentRoute!['points']);

    for (LatLng point in routePoints) {
      double distance = geolocator.Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        point.latitude,
        point.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  Map<String, dynamic>? getClosestAllowedDestination(LatLng destination) {
    Map<String, dynamic>? closestAllowed;
    double minDistance = double.infinity;

    for (Map<String, dynamic> allowed in allowedDestinations) {
      double distance = geolocator.Geolocator.distanceBetween(
        allowed['lat'],
        allowed['lng'],
        destination.latitude,
        destination.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestAllowed = allowed;
      }
    }

    return closestAllowed;
  }

  Future<List<Map<String, dynamic>>> searchLocations(String query) async {
    final String lowercaseQuery = query.toLowerCase();
    final List<Map<String, dynamic>> allResults = [];

    final List<Map<String, dynamic>> allowedResults = allowedDestinations
        .where((destination) =>
            destination['name'].toLowerCase().contains(lowercaseQuery))
        .map((destination) => {
              ...destination,
              'isAllowedDestination': true,
              'type': 'route_stop',
            })
        .toList();

    allResults.addAll(allowedResults);

    try {
      String url = 'https://places.googleapis.com/v1/places:searchText';

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey!,
          'X-Goog-FieldMask':
              'places.displayName,places.formattedAddress,places.location,places.priceLevel'
        },
        body: json.encode({
          "textQuery": query,
          "locationBias": {
            "circle": {
              "center": {"latitude": 16.0439, "longitude": 120.3331},
              "radius": 50000.0
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data != null && data['places'] != null) {
          List<dynamic> placesResults = data['places'];

          for (var result in placesResults) {
            final placeName = result['displayName']['text'];
            final placeLat = result['location'] != null
                ? result['location']['latitude']
                : null;
            final placeLng = result['location'] != null
                ? result['location']['longitude']
                : null;

            bool isNearRoute = false;
            if (placeLat != null && placeLng != null) {
              for (var allowed in allowedDestinations) {
                final distance = haversineDistance(
                    placeLat, placeLng, allowed['lat'], allowed['lng']);
                if (distance < 1000) {
                  isNearRoute = true;
                  break;
                }
              }
            }

            allResults.add({
              'name': placeName,
              'lat': placeLat,
              'lng': placeLng,
              'isAllowedDestination': false,
              'isNearRoute': isNearRoute,
              'type': isNearRoute ? 'near_route' : 'other',
            });
          }
        }
      }
    } catch (e) {
      print('Google Places search error: $e');
    }

    allResults.sort((a, b) {
      if (a['isAllowedDestination'] == true &&
          b['isAllowedDestination'] != true) return -1;
      if (a['isAllowedDestination'] != true &&
          b['isAllowedDestination'] == true) return 1;
      if (a['isNearRoute'] == true && b['isNearRoute'] != true) return -1;
      if (a['isNearRoute'] != true && b['isNearRoute'] == true) return 1;
      return 0;
    });

    return allResults.sublist(0, allResults.length < 7 ? allResults.length : 7);
  }

  Future<void> handleSearchAndRoute(String destination) async {
    try {
      LatLng destinationLatLng = await _getLatLngFromAddress(destination);
      Map<String, dynamic>? closestAllowedDestination =
          getClosestAllowedDestination(destinationLatLng);

      if (closestAllowedDestination == null) {
        print('Destination is not within allowed route');
        return;
      }

      Location position = await getLocationandSpeed();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      LatLng closestLatLng = LatLng(
        closestAllowedDestination['lat'],
        closestAllowedDestination['lng'],
      );

      print('Closest destination: ${closestAllowedDestination['name']}');

      double initialDistance = geolocator.Geolocator.distanceBetween(
        currentLocation.latitude,
        currentLocation.longitude,
        closestLatLng.latitude,
        closestLatLng.longitude,
      );

      if (initialDistance <= 2000) {
        if (_showDestinationApproachingCallback != null) {
          _showDestinationApproachingCallback!(
              "${closestAllowedDestination['name']} (already nearby)");
        }
        return;
      }

      _passedPoints.clear();

      await getRouteAndETA(currentLocation, closestLatLng);
      startTracking(closestLatLng);
    } catch (e) {
      print('Error handling search and route: $e');
    }
  }

  Future<void> getRouteAndETA(LatLng origin, LatLng destination) async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&mode=driving'
        '&alternatives=true'
        '&key=$apiKey';

    try {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        // Get the best route
        var route = data['routes'][0];

        // Decode the overview polyline
        List<PointLatLng> points = PolylinePoints()
            .decodePolyline(route['overview_polyline']['points']);

        // Create the main route polyline
        _createRoutePolylines(points, destination);

        // Get ETA and distance
        String duration = route['legs'][0]['duration']['text'];
        String distance = route['legs'][0]['distance']['text'];

        print('ETA: $duration, Distance: $distance');

        // Store route information for tracking
        _currentRoute = {
          'points': points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
          'destination': destination,
          'startTime': DateTime.now(),
        };

        // Reset passed points
        _passedPoints.clear();
      } else {
        print('Error: ${data['status']} - ${data['error_message']}');
      }
    } catch (e) {
      print('Route API error: $e');
    }
  }

  void _createRoutePolylines(List<PointLatLng> points, LatLng destination) {
    List<LatLng> polylineCoordinates =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    // Main route polyline (Google Maps style)
    Polyline mainRoute = Polyline(
      polylineId: PolylineId('main_route'),
      color: _routeColor,
      width: _routeWidth,
      points: polylineCoordinates,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );

    // Destination marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destination,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: 'Destination'),
    );

    polylines.clear();
    markersNotifier.value.clear();

    polylines.add(mainRoute);
    markersNotifier.value.add(destinationMarker);

    polylineNotifier.value = polylines;
    markersNotifier.notifyListeners();
  }

  void _updateRouteProgress(LatLng currentPosition) {
    if (_currentRoute == null || _currentRoute!['points'] == null) return;

    List<LatLng> allPoints = List<LatLng>.from(_currentRoute!['points']);

    // Find the closest point on the route to current position
    int closestIndex = _findClosestPointIndex(currentPosition, allPoints);

    if (closestIndex != -1) {
      // Mark all points up to the closest index as passed
      for (int i = 0; i <= closestIndex; i++) {
        if (!_passedPoints.contains(allPoints[i])) {
          _passedPoints.add(allPoints[i]);
        }
      }

      // Update the polylines to show passed vs remaining route
      _updateRouteVisualization(allPoints);
    }
  }

  int _findClosestPointIndex(LatLng position, List<LatLng> points) {
    double minDistance = double.infinity;
    int closestIndex = -1;

    for (int i = 0; i < points.length; i++) {
      double distance = geolocator.Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        points[i].latitude,
        points[i].longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  void _updateRouteVisualization(List<LatLng> allPoints) {
    // Separate passed and remaining points
    List<LatLng> passedPoints = _passedPoints.toSet().toList();
    List<LatLng> remainingPoints =
        allPoints.where((point) => !_passedPoints.contains(point)).toList();

    polylines.clear();

    // Create passed route polyline (lighter color)
    if (passedPoints.length > 1) {
      Polyline passedRoute = Polyline(
        polylineId: PolylineId('passed_route'),
        color: _passedRouteColor,
        width: _passedRouteWidth,
        points: passedPoints,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      );
      polylines.add(passedRoute);
    }

    // Create remaining route polyline (main color)
    if (remainingPoints.length > 1) {
      Polyline remainingRoute = Polyline(
        polylineId: PolylineId('remaining_route'),
        color: _routeColor,
        width: _routeWidth,
        points: remainingPoints,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      );
      polylines.add(remainingRoute);
    }

    polylineNotifier.value = polylines;
  }

  Future<LatLng> _getLatLngFromAddress(String address) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      double lat = data['results'][0]['geometry']['location']['lat'];
      double lng = data['results'][0]['geometry']['location']['lng'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to get location');
    }
  }

  Future<Uint8List> resizeImage(Uint8List data, int width, int height) async {
    final codec = await ui.instantiateImageCodec(
      data,
      targetWidth: width,
      targetHeight: height,
    );
    final frameInfo = await codec.getNextFrame();
    final byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void setMap(GoogleMapController controller) async {
    googleMapController = controller;

    Uint8List carData =
        (await rootBundle.load('assets/bus_icon.png')).buffer.asUint8List();
    Uint8List personData =
        (await rootBundle.load('assets/person.png')).buffer.asUint8List();

    carImageData = await resizeImage(carData, 100, 100);
    personImageData = await resizeImage(personData, 80, 80);
  }

  void _updateMarkers() {
    markersNotifier.value = busses.values.toSet().union(people.values.toSet());
  }

  Future<Location> getLocationandSpeed() async {
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    geolocator.Position loc = await geolocator.Geolocator.getCurrentPosition();
    return Location(
      latitude: loc.latitude,
      longitude: loc.longitude,
      speed: loc.speed * 3.6,
      timestamp: loc.timestamp.toString(),
    );
  }

  Future<bool> getPermission() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      loc.Location location = loc.Location();
      if (!await location.serviceEnabled()) {
        bool enabled = await location.requestService();
        return enabled;
      }
      return true;
    } else if (status.isDenied) {
      print("Location permission denied.");
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied. Open app settings.");
      await openAppSettings();
    }
    return false;
  }

  showMyLocation() async {
    bool serviceEnabled =
        await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await getPermission();
      if (!serviceEnabled) {
        print("User denied enabling GPS.");
        return;
      }
    }
    // geolocator.Position position =
    //     await geolocator.Geolocator.getCurrentPosition();
    // googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(
    //   LatLng(position.latitude, position.longitude),
    //   14,
    // ));
    showMyLocationBool.value = true;
  }

  hideMyLocation() {
    // googleMapController?.animateCamera(
    //   CameraUpdate.newLatLngZoom(
    //     const LatLng(0.0, 0.0), // Move the camera away to hide location
    //     1,
    //   ),
    // );
    showMyLocationBool.value = false;

    positionStream?.cancel();
    positionStream = null;
    _currentRoute = null;
    _passedPoints.clear();

    // Clear all polylines and notify listeners
    polylines.clear();
    polylineNotifier.value = polylines;

    // Also clear the destination marker
    markersNotifier.value
        .removeWhere((marker) => marker.markerId.value == 'destination');
    markersNotifier.notifyListeners();
  }

  Future<void> createOneBus(String bus, num lng, num lat, double speed) async {
    if (googleMapController == null || carImageData == null) return;

    final marker = Marker(
      markerId: MarkerId(bus),
      position: LatLng(lat.toDouble(), lng.toDouble()),
      icon: BitmapDescriptor.fromBytes(carImageData!),
      infoWindow: InfoWindow(
        title: "This bus is empty",
        snippet: "Speed: ${speed.toStringAsFixed(2)} km/hr",
      ),
      onTap: () {
        googleMapController?.showMarkerInfoWindow(MarkerId(bus));
      },
    );

    busses[bus] = marker;
    _updateMarkers();
  }

  Future<void> updateOneBus(String bus, num lng, num lat, double speed) async {
    if (googleMapController == null || !busses.containsKey(bus)) return;

    final updatedMarker = busses[bus]!.copyWith(
      positionParam: LatLng(lat.toDouble(), lng.toDouble()),
      infoWindowParam: InfoWindow(
        title: "This bus is empty",
        snippet: "Speed: ${speed.toStringAsFixed(2)} km/hr",
      ),
    );

    busses[bus] = updatedMarker;
    _updateMarkers();
  }

  Future<void> removeOneBus(String bus) async {
    if (googleMapController == null || !busses.containsKey(bus)) return;
    busses.remove(bus);
    _updateMarkers();
  }

  Future<void> createOnePerson(String person, num lng, num lat) async {
    if (googleMapController == null || personImageData == null) return;
    final marker = Marker(
      markerId: MarkerId(person),
      position: LatLng(lat.toDouble(), lng.toDouble()),
      icon: BitmapDescriptor.fromBytes(personImageData!),
    );
    people[person] = marker;
    _updateMarkers();
  }

  Future<void> updateOnePerson(String person, num lng, num lat) async {
    if (googleMapController == null || !people.containsKey(person)) return;
    final updatedMarker = people[person]!.copyWith(
      positionParam: LatLng(lat.toDouble(), lng.toDouble()),
    );
    people[person] = updatedMarker;
    _updateMarkers();
  }

  Future<void> removeOnePerson(String person) async {
    if (googleMapController == null || !people.containsKey(person)) return;
    people.remove(person);
    _updateMarkers();
  }
}
