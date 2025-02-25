import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart' as loc;

mixin Tracker {
  static MapboxMap? mapboxMap;
  static PointAnnotationManager? pointAnnotationManager;
  static PointAnnotation? pointAnnotation;
  static Map<String, PointAnnotation> busses = HashMap();
  static Map<String, PointAnnotation> people = HashMap();

  static ByteData? carBytes;
  static Uint8List? carImageData;
  static ByteData? personBytes;
  static Uint8List? personImageData;

  void setMap(MapboxMap map) async {
    mapboxMap = map;
    pointAnnotationManager =
        await mapboxMap?.annotations.createPointAnnotationManager();
    carBytes = await rootBundle.load('assets/bus.png');
    carImageData = carBytes?.buffer.asUint8List();
    personBytes = await rootBundle.load('assets/person.png');
    personImageData = personBytes?.buffer.asUint8List();
  }

  Future<Location> getLocationandSpeed() async {
    bool serviceEnabled;
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    geolocator.Position loc = await geolocator.Geolocator.getCurrentPosition();

    return Location(
      latitude: loc.latitude,
      longitude: loc.longitude,
      speed: loc.speed,
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
      print(
          "Location permission denied."); // TODO: do something or show something
    } else if (status.isPermanentlyDenied) {
      print(
          "Location permission permanently denied. Open app settings."); // TODO: do something or show something
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
        print(
            "User denied enabling GPS."); // TODO: do something or show something
        return;
      }
    }
    mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: true));
  }

  hideMyLocation() {
    mapboxMap?.location
        .updateSettings(LocationComponentSettings(enabled: false));
  }

  Future<void> createOneBus(String bus, num lng, num lat) async {
    if (pointAnnotationManager == null) {
      return;
    }
    final annotation = await pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            lng,
            lat,
          ),
        ),
        image: carImageData,
        iconSize: 0.1,
      ),
    );
    busses.addAll({bus: annotation!});
  }

  Future<void> updateOneBus(String bus, num lng, num lat) async {
    if (pointAnnotationManager == null || busses.isEmpty) return;
    if (!busses.containsKey(bus)) return;
    busses[bus]?.geometry = Point(coordinates: Position(lng, lat));

    pointAnnotationManager!.update(busses[bus]!);
  }

  Future<void> removeOneBus(String bus) async {
    if (pointAnnotationManager == null || busses.isEmpty) return;

    final removePointAnnotation = busses.remove(bus);
    pointAnnotationManager!.delete(removePointAnnotation!);
  }

  Future<void> createOnePerson(String person, num lng, num lat) async {
    if (pointAnnotationManager == null) {
      return;
    }
    final annotation = await pointAnnotationManager?.create(
      PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            lng,
            lat,
          ),
        ),
        image: personImageData,
        iconSize: 0.1,
      ),
    );
    people.addAll({person: annotation!});
  }

  Future<void> updateOnePerson(String person, num lng, num lat) async {
    if (pointAnnotationManager == null || people.isEmpty) return;
    if (!people.containsKey(person)) return;
    people[person]?.geometry = Point(coordinates: Position(lng, lat));

    pointAnnotationManager!.update(people[person]!);
  }

  Future<void> removeOnePerson(String person) async {
    if (pointAnnotationManager == null || people.isEmpty) return;

    final removePointAnnotation = people.remove(person);
    pointAnnotationManager!.delete(removePointAnnotation!);
  }
}
