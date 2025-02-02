import 'package:equatable/equatable.dart';

abstract class TrackerState extends Equatable {
  const TrackerState();

  @override
  List<Object> get props => [];
}

class ConnectingSocket extends TrackerState {}

class ConnectedSocket extends TrackerState {}

class TrackMyVehicleInitializing extends TrackerState {}

class TrackMyVehicleStarted extends TrackerState {}

class TrackMyVehicleStopped extends TrackerState {}

class ConnectionError extends TrackerState {
  final String error;

  const ConnectionError(this.error);

  @override
  List<Object> get props => [error];
}
