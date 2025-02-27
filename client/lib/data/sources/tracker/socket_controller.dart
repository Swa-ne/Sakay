import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
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

class TrackingSocketControllerImpl extends TrackingSocketController
    with Tracker {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

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
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
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
      if (!Tracker.busses.containsKey(data['user'])) {
        if (!pendingCreations.contains(data['user'])) {
          pendingCreations.add(data['user']);
          await createOneBus(data['user'], busLoc.longitude, busLoc.latitude);
          pendingCreations.remove(data['user']);
        }
      } else {
        await updateOneBus(
          data['user'],
          busLoc.longitude,
          busLoc.latitude,
        );
      }
    });

    socket.on('track-my-vehicle-stop', (data) async {
      await removeOneBus(data['user']);
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
      if (!Tracker.people.containsKey(data['user'])) {
        if (!pendingCreations.contains(data['user'])) {
          pendingCreations.add(data['user']);
          await createOnePerson(
              data['user'], personLoc.longitude, personLoc.latitude);
          pendingCreations.remove(data['user']);
        }
      } else {
        await updateOnePerson(
          data['user'],
          personLoc.longitude,
          personLoc.latitude,
        );
      }
    });

    socket.on('track-me-stop', (data) async {
      await removeOnePerson(data['user']);
    });
  }

  @override
  void trackMyVehicle() {
    showMyLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Location loc = await getLocationandSpeed();

      socket.emit('track-my-vehicle', loc.toJson());
    });
  }

  @override
  void stopTrackMyVehicle() {
    hideMyLocation();
    socket.emit('pause-track-my-vehicle');
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void trackMe() {
    showMyLocation();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      Location loc = await getLocationandSpeed();

      socket.emit('track-me', loc.toJson());
    });
  }

  @override
  void stopTrackMe() {
    hideMyLocation();
    socket.emit('pause-track-me');
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @override
  void disconnect() {
    socket.disconnect();
  }
}
