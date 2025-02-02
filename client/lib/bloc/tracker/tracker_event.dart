import 'package:equatable/equatable.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class StartTrackMyVehicleEvent extends TrackerEvent {}

class StopTrackMyVehicleEvent extends TrackerEvent {}

class ConnectEvent extends TrackerEvent {}
