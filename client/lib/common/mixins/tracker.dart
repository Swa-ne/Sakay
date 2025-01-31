import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:location/location.dart' as loc;

mixin Tracker {
  static MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  CircleAnnotation? circleAnnotation;
  final Map<String, CircleAnnotation> busses = HashMap();

// Function to add or update a user's marker

  void setMap(MapboxMap map) async {
    mapboxMap = map;
    circleAnnotationManager =
        await mapboxMap?.annotations.createCircleAnnotationManager();
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
      timestamp: loc.timestamp,
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

  Future<void> createOneAnnotation(String bus, num lng, num lat) async {
    final annotation = await circleAnnotationManager?.create(
      CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(
            lng,
            lat,
          ),
        ),
        circleColor: Colors.yellow.hashCode,
        circleRadius: 12.0,
      ),
    );
    busses.addAll({bus: annotation!});
  }

  Future<void> updateOneAnnotations(String bus, num lng, num lat) async {
    if (circleAnnotationManager == null || busses.isEmpty) return;

    busses[bus]?.geometry = Point(coordinates: Position(lng, lat));

    circleAnnotationManager!.update(busses[bus]!);
  }

  void removeOneAnnotations(String bus) {
    if (circleAnnotationManager == null || busses.isEmpty) return;

    final lastAnnotation = busses.remove(bus);
    circleAnnotationManager!.delete(lastAnnotation!);
  }
}
