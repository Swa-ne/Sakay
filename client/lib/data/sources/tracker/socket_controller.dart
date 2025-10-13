import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';

final _apiUrl = "${dotenv.env['API_URL']}/tracking";

abstract class TrackingSocketController {
  void passBloc(TrackerBloc bloc);
  Future<void> connect();
  Future<void> connectDriver();
  void trackMyVehicle();
  void stopTrackMyVehicle();
  void trackMe();
  void stopTrackMe();
  void disconnect();
}

class TrackingSocketControllerImpl extends TrackingSocketController {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final Tracker tracker = Tracker();

  static final TrackingSocketControllerImpl _singleton =
      TrackingSocketControllerImpl._internal();
  late IO.Socket socket;
  late TrackerBloc trackerBloc;
  Set<String> pendingCreations = {};
  Timer? _locationTimer;

  factory TrackingSocketControllerImpl() {
    return _singleton;
  }

  @override
  void passBloc(TrackerBloc bloc) {
    trackerBloc = bloc;
  }

  TrackingSocketControllerImpl._internal();

  @override
  Future<void> connect() async {
    _tokenController.removeTrackerOn();
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'auth': {
        'token': await _tokenController.getAccessToken(),
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to tracking socket');
    });

    socket.on('update-map', (data) async {
      Location busLoc = Location.fromJson(data['location']);
      if (!tracker.busses.containsKey(data['user'])) {
        if (!pendingCreations.contains(data['user'])) {
          pendingCreations.add(data['user']);
          await tracker.createOneBus(
            data['user'],
            busLoc.longitude,
            busLoc.latitude,
            busLoc.speed,
            BusModel.fromJson(data['bus']),
          );
          pendingCreations.remove(data['user']);
        }
      } else {
        await tracker.updateOneBus(
          data['user'],
          busLoc.longitude,
          busLoc.latitude,
          busLoc.speed,
          BusModel.fromJson(data['bus']),
        );
      }
    });

    socket.on('track-my-vehicle-stop', (data) async {
      await tracker.removeOneBus(data['user']);
    });

    socket.onDisconnect((_) {
      print('Disconnected from tracking socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  @override
  Future<void> connectDriver() async {
    socket.on('update-map-driver', (data) async {
      Location personLoc = Location.fromJson(data['location']);
      if (!tracker.people.containsKey(data['user'])) {
        if (!pendingCreations.contains(data['user'])) {
          pendingCreations.add(data['user']);
          await tracker.createOnePerson(
              data['user'], personLoc.longitude, personLoc.latitude);
          pendingCreations.remove(data['user']);
        }
      } else {
        await tracker.updateOnePerson(
          data['user'],
          personLoc.longitude,
          personLoc.latitude,
        );
      }
    });

    socket.on('track-me-stop', (data) async {
      await tracker.removeOnePerson(data['user']);
    });

    socket.on('vehicle-inuse', (data) async {
      tracker.hideMyLocation();
      trackerBloc.add(InUseDriverEvent());
    });
  }

  @override
  void trackMyVehicle() {
    tracker.showMyLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Location loc = await tracker.getLocationandSpeed();

      socket.emit('track-my-vehicle', loc.toJson());
    });
  }

  @override
  void stopTrackMyVehicle() {
    tracker.hideMyLocation();
    socket.emit('pause-track-my-vehicle');
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void trackMe() {
    tracker.showMyLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Location loc = await tracker.getLocationandSpeed();

      socket.emit('track-me', loc.toJson());
    });
  }

  @override
  void stopTrackMe() {
    tracker.hideMyLocation();
    socket.emit('pause-track-me');
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
