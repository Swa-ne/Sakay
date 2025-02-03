import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/data/models/location.dart';
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
  static final SocketControllerImpl _singleton =
      SocketControllerImpl._internal();
  late IO.Socket socket;
  late TrackerBloc trackerBloc;
  Timer? _locationTimer;

  factory SocketControllerImpl() {
    return _singleton;
  }
  void passBloc(TrackerBloc bloc) {
    trackerBloc = bloc;
  }

  SocketControllerImpl._internal();

  @override
  void connect() {
    socket = IO.io(_apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {
        'token':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjcwZDYxNjY2Y2M5YWNlZjI1MDllZTEzIiwiZW1haWwiOiJ1bmlsb2RnZXRlc3RAZ21haWwuY29tIiwidXNlcm5hbWUiOiJVbmlMb2RnZSIsImZ1bGxfbmFtZSI6IlRlc3QgIEFjY291bnQiLCJpYXQiOjE3Mjg5MzA3NzMsImV4cCI6MTcyODkzMjU3M30.bv0vHAii6VUIwPCht9bhyqoFdZ0lYK6uBZyQrJKbVeE",
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
        await createOneAnnotation(
          data['user'],
          busLoc.longitude,
          busLoc.latitude,
        );
      } else {
        await updateOneAnnotations(
          data['user'],
          busLoc.longitude,
          busLoc.latitude,
        );
      }
    });

    socket.on('track-my-vehicle-stop', (data) async {
      await removeOneAnnotations(data['user']);
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
