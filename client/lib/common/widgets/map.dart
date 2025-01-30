import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:sakay_app/common/mixins/tracker.dart';

class MyMapWidget extends StatefulWidget {
  const MyMapWidget({super.key});

  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapWidget> with Tracker {
  _onMapCreated(MapboxMap mapboxMap) {
    setState(() {
      setMap(mapboxMap);
    });
  }

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
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      styleUri: MapboxStyles.STANDARD,
      onMapCreated: _onMapCreated,
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(120.286585, 16.033410)),
        zoom: 11.0,
      ),
    );

    return SizedBox.expand(
      child: mapWidget,
    );
  }
}
