import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/data/models/location.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';

final _apiUrl = "${dotenv.env['API_URL']}";

abstract class SocketController {
  void connect();
  void trackMyVehicle();
  void stopTrackMyVehicle();
  void disconnect();
}

class SocketControllerImpl extends SocketController with Tracker {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  static final SocketControllerImpl _singleton =
      SocketControllerImpl._internal();
  late IO.Socket socket;
  late TrackerBloc trackerBloc;
  Set<String> pendingCreations = {};
  Timer? _locationTimer;

  factory SocketControllerImpl() {
    return _singleton;
  }
  void passBloc(TrackerBloc bloc) {
    trackerBloc = bloc;
  }

  SocketControllerImpl._internal();

  @override
  void connect() async {
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token': await _tokenController.getAccessToken(),
      }
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket');
    });

    socket.on('update-map', (data) async {
      // TODO: update the map
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
      print('Disconnected from socket');
    });

    socket.onError((error) {
      print('Socket error: $error');
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
  void disconnect() {
    socket.disconnect();
  }
}
