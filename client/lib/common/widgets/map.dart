import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MyMapWidget extends StatefulWidget {
  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapWidget> {
  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;
  int _accuracyColor = 0;
  int _pulsingColor = 0;
  int _accuracyBorderColor = 0;
  double _puckScale = 10.0;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _show() {
    return TextButton(
      child: Text('show location'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: true));
      },
    );
  }

  Widget _hide() {
    return TextButton(
      child: Text('hide location'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: false));
      },
    );
  }

  Widget _showBearing() {
    return TextButton(
      child: Text('show location bearing'),
      onPressed: () {
        mapboxMap?.location.updateSettings(
            LocationComponentSettings(puckBearingEnabled: true));
      },
    );
  }

  Widget _hideBearing() {
    return TextButton(
      child: Text('hide location bearing'),
      onPressed: () {
        mapboxMap?.location.updateSettings(
            LocationComponentSettings(puckBearingEnabled: false));
      },
    );
  }

  Widget _showPulsing() {
    return TextButton(
      child: Text('show pulsing'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(pulsingEnabled: true));
      },
    );
  }

  Widget _hidePulsing() {
    return TextButton(
      child: Text('hide pulsing'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(pulsingEnabled: false));
      },
    );
  }

  Widget _showAccuracy() {
    return TextButton(
      child: Text('show accuracy'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(showAccuracyRing: true));
      },
    );
  }

  Widget _hideAccuracy() {
    return TextButton(
      child: Text('hide accuracy'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(showAccuracyRing: false));
      },
    );
  }

  Widget _switchAccuracyBorderColor() {
    return TextButton(
      child: Text('switch accuracy border color'),
      onPressed: () {
        _accuracyBorderColor++;
        _accuracyBorderColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            accuracyRingBorderColor: colors[_accuracyBorderColor].value));
      },
    );
  }

  Widget _switchAccuracyColor() {
    return TextButton(
      child: Text('switch accuracy color'),
      onPressed: () {
        _pulsingColor++;
        _pulsingColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            accuracyRingColor: colors[_pulsingColor].value));
      },
    );
  }

  Widget _switchPulsingColor() {
    return TextButton(
      child: Text('switch pulsing color'),
      onPressed: () {
        _accuracyColor++;
        _accuracyColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            pulsingColor: colors[_accuracyColor].value));
      },
    );
  }

  Widget _switchLocationPuck3D_duck() {
    return TextButton(
      child: Text('switch to 3d puck with duck model'),
      onPressed: () {
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            locationPuck: LocationPuck(
                locationPuck3D: LocationPuck3D(
                    modelUri:
                        "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                    modelScale: [_puckScale, _puckScale, _puckScale]))));
      },
    );
  }

  Widget _switchLocationPuck3D_car() {
    return TextButton(
      child: Text('switch to 3d puck with car model'),
      onPressed: () {
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            locationPuck: LocationPuck(
                locationPuck3D: LocationPuck3D(
                    modelUri: "asset://assets/sportcar.glb",
                    modelScale: [_puckScale, _puckScale, _puckScale]))));
      },
    );
  }

  Widget _switchPuckScale() {
    return TextButton(
      child: Text('scale 3d puck'),
      onPressed: () {
        _puckScale /= 2;
        if (_puckScale < 1) {
          _puckScale = 10.0;
        }
        print("Scale : $_puckScale");
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            locationPuck: LocationPuck(
                locationPuck3D: LocationPuck3D(
                    modelUri:
                        "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                    modelScale: [_puckScale, _puckScale, _puckScale]))));
      },
    );
  }

  Widget _getPermission() {
    return TextButton(
      child: Text('get location permission'),
      onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        print("Location granted : $status");
      },
    );
  }

  Widget _getSettings() {
    return TextButton(
      child: Text('get settings'),
      onPressed: () {
        mapboxMap?.location.getSettings().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("""
                  Location settings : 
                    enabled : ${value.enabled}, 
                    puckBearingEnabled : ${value.puckBearingEnabled}
                    puckBearing : ${value.puckBearing}
                    pulsing : ${value.pulsingEnabled}
                    pulsing radius : ${value.pulsingMaxRadius}
                    pulsing color : ${value.pulsingColor}
                    accuracy :  ${value.showAccuracyRing},
                    accuracy color :  ${value.accuracyRingColor}
                    accuracyRingBorderColor : ${value.accuracyRingBorderColor}
                    """
                      .trim()),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
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
    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _getPermission(),
        _show(),
        _hide(),
        _switchLocationPuck3D_duck(),
        _switchLocationPuck3D_car(),
        _switchPuckScale(),
        _showBearing(),
        _hideBearing(),
        _showAccuracy(),
        _hideAccuracy(),
        _showPulsing(),
        _hidePulsing(),
        _switchAccuracyColor(),
        _switchPulsingColor(),
        _switchAccuracyBorderColor(),
        _getSettings(),
      ],
    );
    return SizedBox.expand(
      child: mapWidget,
    );
  }
}
