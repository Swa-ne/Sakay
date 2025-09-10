import 'package:equatable/equatable.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class StartTrackMyVehicleEvent extends TrackerEvent {}

class StopTrackMyVehicleEvent extends TrackerEvent {}

class StartTrackMeEvent extends TrackerEvent {}

class StopTrackMeEvent extends TrackerEvent {}

class ConnectEvent extends TrackerEvent {}

class ConnectDriverEvent extends TrackerEvent {}

class InUseDriverEvent extends TrackerEvent {}
