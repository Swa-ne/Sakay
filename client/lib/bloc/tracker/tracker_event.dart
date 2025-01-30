import 'package:equatable/equatable.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class StartTrackMeEvent extends TrackerEvent {}

class StopTrackMeEvent extends TrackerEvent {}

class ConnectEvent extends TrackerEvent {}
