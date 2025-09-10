import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakay_app/common/mixins/tracker.dart';

class MyMapWidget extends StatefulWidget {
  final MapType mapType;
  final bool showTraffic;
  
  const MyMapWidget({
    super.key,
    required this.mapType,
    required this.showTraffic,
  });

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
  void didUpdateWidget(MyMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update map type when it changes
    if (oldWidget.mapType != widget.mapType && _mapController.isCompleted) {
      _mapController.future.then((controller) {
        // Map type is handled by the mapType parameter in GoogleMap widget
        setState(() {});
      });
    }
    
    // Update traffic display when it changes
    if (oldWidget.showTraffic != widget.showTraffic && _mapController.isCompleted) {
      _mapController.future.then((controller) {
        final mapStyle = widget.showTraffic ? '' : '''
        [
          {
            "featureType": "poi",
            "elementType": "all",
            "stylers": [
              { "visibility": "off" }
            ]
          }
        ]''';
        controller.setMapStyle(mapStyle);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    mapType: widget.mapType,
                    onMapCreated: (GoogleMapController controller) async {
                      final mapStyle = widget.showTraffic ? '' : '''
                      [
                        {
                          "featureType": "poi",
                          "elementType": "all",
                          "stylers": [
                            { "visibility": "off" }
                          ]
                        }
                      ]''';
                      controller.setMapStyle(mapStyle);
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
                    trafficEnabled: widget.showTraffic,
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