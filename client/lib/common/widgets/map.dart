import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakay_app/common/mixins/tracker.dart';

class MyMapWidget extends StatefulWidget {
  const MyMapWidget({super.key});

  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapWidget> {
  final Completer<GoogleMapController> _mapController = Completer();
  final Tracker tracker = Tracker();

  bool trackMe = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MapType _currentMapType = MapType.normal;
    return SizedBox.expand(
      child: ValueListenableBuilder<Set<Marker>>(
        valueListenable: tracker.markersNotifier,
        builder: (context, markers, _) {
          return ValueListenableBuilder<bool>(
            valueListenable: tracker.showMyLocationBool,
            builder: (context, showMyLocation, _) {
              return ValueListenableBuilder<Set<Polyline>>(
                valueListenable: tracker.polylineNotifier,
                builder: (context, polylines, child) {
                  return GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(16.033410, 120.286585),
                      zoom: 12.0,
                    ),
                    mapType: _currentMapType,
                    onMapCreated: (GoogleMapController controller) async {
                      controller.setMapStyle('''[
                          {
                            "featureType": "poi",
                            "elementType": "all",
                            "stylers": [
                              { "visibility": "off" }
                            ]
                          }
                        ]''');
                      setState(() {
                        tracker.setMap(controller);
                      });
                      _mapController.complete(controller);
                    },
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationEnabled: showMyLocation,
                    myLocationButtonEnabled: false,
                    markers: markers,
                    polylines: polylines,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
