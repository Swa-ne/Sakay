import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(title: const Text("Map")),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.7749, -122.4194), // Example: San Francisco
            zoom: 12,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("Map")),
        body: const Center(
          child: Text("Maps are not supported on this platform."),
        ),
      );
    }
  }
}
