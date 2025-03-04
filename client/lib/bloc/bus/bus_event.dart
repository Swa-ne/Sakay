import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';

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

class GetAllBusesAndDriversEvent extends BusEvent {
  final DateTime time;

  const GetAllBusesAndDriversEvent(this.time);

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

class DeleteBusEvent extends BusEvent {
  final BusModel bus;

  const DeleteBusEvent(this.bus);

  @override
  List<Object> get props => [bus];
}

class GetAllDriversEvent extends BusEvent {
  final DateTime time;

  const GetAllDriversEvent(this.time);

  @override
  List<Object> get props => [time];
}

class GetDriverEvent extends BusEvent {
  final String driver_id;

  const GetDriverEvent(this.driver_id);

  @override
  List<Object> get props => [driver_id];
}

class AssignUserToBusEvent extends BusEvent {
  final String user_id;
  final String bus_id;

  const AssignUserToBusEvent(this.user_id, this.bus_id);

  @override
  List<Object> get props => [user_id, bus_id];
}

class RemoveAssignUserToBusEvent extends BusEvent {
  final BusModel bus;
  final UserModel driver;

  const RemoveAssignUserToBusEvent(this.bus, this.driver);

  @override
  List<Object> get props => [bus, driver];
}
