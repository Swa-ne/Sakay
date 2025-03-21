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
      "name": "Pangasinan State University",
      "lat": 16.030899,
      "lng": 120.230123,
    },
    {
      "name": "Lingayen Municipal Hall",
      "lat": 16.020103,
      "lng": 120.230726,
    },
  ];

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
  void startTracking(LatLng destination) {
    positionStream = geolocator.Geolocator.getPositionStream(
      locationSettings: const geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geolocator.Position position) async {
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

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
  }

  double _getDistanceToPolyline(LatLng currentLocation) {
    double minDistance = double.infinity;

    for (Polyline polyline in polylines) {
      for (LatLng point in polyline.points) {
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
    String url = 'https://places.googleapis.com/v1/places:searchText';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey!,
        'X-Goog-FieldMask':
            'places.displayName,places.formattedAddress,places.priceLevel'
      },
      body: json.encode({"textQuery": query}),
    );
    var data = jsonDecode(response.body);

    if (data != null) {
      List<dynamic> results = data['places'];
      return results.map((result) {
        return {
          'name': result['displayName']['text'],
          // 'lat': result['geometry']['location']['lat'],
          // 'lng': result['geometry']['location']['lng'],
        };
      }).toList();
    } else {
      print('Error: ${data['status']}');
      return [];
    }
  }

  Future<void> handleSearchAndRoute(String destination) async {
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

    await getRouteAndETA(currentLocation, closestLatLng);

    startTracking(closestLatLng);
  }

  Future<void> getRouteAndETA(LatLng origin, LatLng destination) async {
    print(
        "taetae ${origin.latitude} ${origin.longitude} ${destination.latitude} ${destination.longitude}");
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=transit&transit_mode=bus&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    if (data['status'] == 'OK') {
      List<PointLatLng> points = PolylinePoints()
          .decodePolyline(data['routes'][0]['overview_polyline']['points']);
      _createPolylines(points);

      String duration = data['routes'][0]['legs'][0]['duration']['text'];
      print('ETA: $duration');
    } else {
      print('Error: ${data['status']}');
    }
  }

  void _createPolylines(List<PointLatLng> points) {
    List<LatLng> polylineCoordinates =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    Polyline polyline = Polyline(
      polylineId: PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: polylineCoordinates,
    );

    polylines.clear();
    polylines.add(polyline);
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
