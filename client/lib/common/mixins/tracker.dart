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
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

class Tracker {
  static final Tracker _instance = Tracker._internal();
  factory Tracker() => _instance;

  Tracker._internal();

  static List<Map<String, dynamic>> allowedDestinations = [
    {
      "name": "Caltex - Dagupan City",
      "lat": 16.038356,
      "lng": 120.333618,
    },
    {
      "name": "University of Luzon",
      "lat": 16.039257,
      "lng": 120.335644,
    },
    {
      "name": "Zamora Street",
      "lat": 16.039600,
      "lng": 120.336417,
    },
    {
      "name": "Galvan Street",
      "lat": 16.039978,
      "lng": 120.337329,
    },
    {
      "name": "St. Joseph Drug Store - Rizal Street, Dagupan City",
      "lat": 16.040897,
      "lng": 120.339501,
    },
    {
      "name": "Pangasinan Merchant Marine Academy(PAMMA)",
      "lat": 16.041865,
      "lng": 120.341745,
    },
    {
      "name": "Victory Liner - Dagupan City",
      "lat": 16.042736,
      "lng": 120.343764,
    },
    {
      "name": "Development Bank of the Philippines - Dagupan City",
      "lat": 16.043811,
      "lng": 120.344205,
    },
    {
      "name": "SM Hypermarket Dagupan",
      "lat": 16.045222,
      "lng": 120.343445,
    },
    {
      "name": "Chowking - AB Fernandez, Dagupan City",
      "lat": 16.045691,
      "lng": 120.342337,
    },
    {
      "name": "City Deluxe Restaurant Downtown",
      "lat": 16.044224,
      "lng": 120.338344,
    },
    {
      "name": "Newstar Shopping Mall - Dagupan",
      "lat": 16.044145,
      "lng": 120.336959,
    },
    {
      "name": "Dagupan City Hall",
      "lat": 16.043928,
      "lng": 120.335211,
    },
    {
      "name": "West Central Elementary School",
      "lat": 16.042923,
      "lng": 120.333472,
    },
    {
      "name": "Cuison Hospital Incorporated",
      "lat": 16.040893,
      "lng": 120.334269,
    },
    {
      "name": "KOREAN PALACE (KUNG JEON RESTAURANT) - Dagupan City",
      "lat": 16.038357,
      "lng": 120.333202,
    },
    // repeats block (goes from top to bottom when from dagupan, goes from bottom to top when from lingayen)
    {
      "name": "Dagupan City National High School",
      "lat": 16.037269,
      "lng": 120.332636,
    },
    {
      "name": "Astrodome",
      "lat": 16.036140,
      "lng": 120.332153,
    },
    {
      "name": "Lyceum-Northwestern University",
      "lat": 16.034859,
      "lng": 120.331570,
    },
    {
      "name": "Malta",
      "lat": 16.033534,
      "lng": 120.330883,
    },
    {
      "name": "Los Pedritos - Tapuac",
      "lat": 16.029187,
      "lng": 120.328743,
    },
    {
      "name": "Meshroom Cafe - Tapuac",
      "lat": 16.029187,
      "lng": 120.328743,
    },
    {
      "name": "Lavarias",
      "lat": 16.024932,
      "lng": 120.326576,
    },
    {
      "name": "CSI Lucao",
      "lat": 16.021238,
      "lng": 120.324135,
    },
    {
      "name": "Angels Pizza - Lucao",
      "lat": 16.020270,
      "lng": 120.322248,
    },
    {
      "name": "Dunkin' - Lucao",
      "lat": 16.019067,
      "lng": 120.319937,
    },
    {
      "name": "Prime Brilliant Minds Academy",
      "lat": 16.016556,
      "lng": 120.314625,
    },
    {
      "name": "Marker Binmaley (Boundary)",
      "lat": 16.015575,
      "lng": 120.312421,
    },
    {
      "name": "Rufina Square",
      "lat": 16.014550,
      "lng": 120.309931,
    },
    {
      "name": "San Jose, Binmaley",
      "lat": 16.011962,
      "lng": 120.303920,
    },
    {
      "name": "Naguilayan, Binmaley",
      "lat": 16.010028,
      "lng": 120.299344,
    },
    {
      "name": "Centrum - Naguilayan, Binmaley",
      "lat": 16.009052,
      "lng": 120.295036,
    },
    {
      "name": "Central Pangasinan Hospital and Medical Center",
      "lat": 16.009445,
      "lng": 120.291720,
    },
    {
      "name": "Caltex Triangle Bus Stop - Binmaley",
      "lat": 16.010442,
      "lng": 120.285579,
    },
    {
      "name": "Manat Bridge - Binmaley",
      "lat": 16.013035,
      "lng": 120.282323,
    },
    {
      "name": "Linoc - Binmaley",
      "lat": 16.014260,
      "lng": 120.281769,
    },
    {
      "name": "Nansangaan - Binmaley",
      "lat": 16.022855,
      "lng": 120.276433,
    },
    {
      "name": "Binmaley Public Market",
      "lat": 16.027963,
      "lng": 120.269639,
    },
    {
      "name": "Binmaley Triangle (ESTASYON)",
      "lat": 16.029056,
      "lng": 120.268714,
    },
    {
      "name": "Manaois Furniture",
      "lat": 16.027752,
      "lng": 120.262536,
    },
    {
      "name": "Boundary Marker Lingayen",
      "lat": 16.025179,
      "lng": 120.253171,
    },
    {
      "name": "Shell - Lingayen",
      "lat": 16.025110,
      "lng": 120.245181,
    },
    {
      "name": "Savewise Supermarket - Lingayen",
      "lat": 16.022626,
      "lng": 120.236803,
    },
    {
      "name": "PNB - Lingayen",
      "lat": 16.0223609,
      "lng": 120.2359898,
    },
    // repeat end
    {
      "name": "Harvent School - Lingayen",
      "lat": 16.0259072,
      "lng": 120.2345061,
    },
    {
      "name": "Kingdom Hall of Jehovah's Witnesses - Lingayen",
      "lat": 16.0292683,
      "lng": 120.23325,
    },
    {
      "name": "Golden Mami House - Lingayen",
      "lat": 16.0308944,
      "lng": 120.2326433,
    },
    {
      "name": "Pangasinan State University",
      "lat": 16.030899,
      "lng": 120.230123,
    },
    {
      "name": "Bo's Coffee - Lingayen",
      "lat": 16.0303872,
      "lng": 120.2285407,
    },
    {
      "name": "7-Eleven - Lingayen",
      "lat": 16.0303872,
      "lng": 120.2285407,
    },
    {
      "name": "YamiTeys Snack House",
      "lat": 16.0285073,
      "lng": 120.2279688,
    },
    {
      "name": "P. Morgan",
      "lat": 16.0270937,
      "lng": 120.2282478,
    },
    {
      "name": "Uson Pigar Pigar - Lingayen",
      "lat": 16.0259742,
      "lng": 120.2284627,
    },
    {
      "name": "Total - Lingayen",
      "lat": 16.0251403,
      "lng": 120.2286114,
    },
    {
      "name": "JK Raider Enterprises",
      "lat": 16.0246013,
      "lng": 120.2287145,
    },
    {
      "name": "PCWORKS - Lingayen",
      "lat": 16.0225447,
      "lng": 120.2291036,
    },
    {
      "name": "Jetti Artacho - Lingayen",
      "lat": 16.0213224,
      "lng": 120.2293242,
    },
    {
      "name": "Amigo - Lingayen",
      "lat": 16.020829,
      "lng": 120.2281878,
    },
    {
      "name": "Mesa de Amor",
      "lat": 16.020694,
      "lng": 120.2274517,
    },
    {
      "name": "UPS Driving School - Lingayen",
      "lat": 16.0202634,
      "lng": 120.2267805,
    },
    {
      "name": "Lingayen Tricycle Terminal",
      "lat": 16.2267805,
      "lng": 120.2276028,
    },
    {
      "name": "Civil Service Commision Director II Office",
      "lat": 16.0185148,
      "lng": 120.2280105,
    },
    {
      "name": "Lingayen Municipal Fish Port",
      "lat": 16.0174397,
      "lng": 120.228884,
    },
    {
      "name": "Lingayen Common Bus Terminal",
      "lat": 16.0178851,
      "lng": 120.230678,
    },
    {
      "name": "McDonald's - Lingayen",
      "lat": 16.0188837,
      "lng": 120.2314203,
    },
    {
      "name": "Lingayen Municipal Hall",
      "lat": 16.020103,
      "lng": 120.230726,
    },
    {
      "name": "The Co-Cathedral Parish of the Epiphany of our Lord",
      "lat": 16.0211435,
      "lng": 120.2322544,
    },
    {
      "name": "BHF Bank - Lingayen",
      "lat": 16.0217193,
      "lng": 120.2333481,
    },
    {
      "name": "Computer Bucket - Lingayen",
      "lat": 16.0219766,
      "lng": 120.23445,
    }
  ];
  final bus_terminal = {
    "name": "LDTC Parking Terminal",
    "lat": 16.004627,
    "lng": 120.223597,
  };

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

  Color _routeColor = Color(0xFF4285F4); // Google Blue
  Color _passedRouteColor = Color(0xFFAECBFA); // Light Google Blue
  int _routeWidth = 6;
  int _passedRouteWidth = 4;

  Map<String, dynamic>? _currentRoute;
  LatLng? _lastPosition;
  List<LatLng> _passedPoints = [];

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
    positionStream = geolocator.Geolocator.getPositionStream(
      locationSettings: const geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geolocator.Position position) async {
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      _updateRouteProgress(currentLocation);

      double distanceToLine = _getDistanceToPolyline(currentLocation);

      if (distanceToLine > 50) {
        print("User deviated from route. Recalculating...");
        await getRouteAndETA(currentLocation, destination);
      }
    });
  }

  void stopTracking() {
    positionStream?.cancel();
    positionStream = null;
    _currentRoute = null;
    _passedPoints.clear();
    polylines.clear();
    polylineNotifier.value = polylines;
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

    return allResults;
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

      // Clear previous route data
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
