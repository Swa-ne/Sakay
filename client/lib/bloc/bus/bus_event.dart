import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/bus.dart';

abstract class BusEvent extends Equatable {
  const BusEvent();

  @override
  List<Object> get props => [];
}

class PostBusEvent extends BusEvent {
  final BusModel bus;

  const PostBusEvent(this.bus);

  @override
  List<Object> get props => [bus];
}

class GetAllBusesEvent extends BusEvent {
  final DateTime time;

  const GetAllBusesEvent(this.time);

  @override
  List<Object> get props => [time];
}

class GetBusEvent extends BusEvent {
  final String bus_id;

  const GetBusEvent(this.bus_id);

  @override
  List<Object> get props => [bus_id];
}

class EditBusEvent extends BusEvent {
  final BusModel bus;

  const EditBusEvent(this.bus);

  @override
  List<Object> get props => [bus];
}

class AssignUserToBusEvent extends BusEvent {
  final String user_id;
  final String bus_id;

  const AssignUserToBusEvent(this.user_id, this.bus_id);

  @override
  List<Object> get props => [user_id, bus_id];
}

class ReassignUserToBusEvent extends BusEvent {
  final String user_id;
  final String bus_id;

  const ReassignUserToBusEvent(this.user_id, this.bus_id);

  @override
  List<Object> get props => [user_id, bus_id];
}
