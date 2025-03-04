import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';

abstract class BusState extends Equatable {
  const BusState();

  @override
  List<Object> get props => [];
}

class BusLoading extends BusState {}

class BusReady extends BusState {}

class SaveBusSuccess extends BusState {
  final BusModel bus;

  const SaveBusSuccess(this.bus);

  @override
  List<Object> get props => [bus];
}

class SaveBusError extends BusState {
  final String error;

  const SaveBusError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllBusesSuccess extends BusState {
  final List<BusModel> buses;

  const GetAllBusesSuccess(this.buses);

  @override
  List<Object> get props => [buses];
}

class GetAllBusesError extends BusState {
  final String error;

  const GetAllBusesError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllBusesAndDriversSuccess extends BusState {
  final List<BusModel> buses;

  const GetAllBusesAndDriversSuccess(this.buses);

  @override
  List<Object> get props => [buses];
}

class GetAllBusesAndDriversError extends BusState {
  final String error;

  const GetAllBusesAndDriversError(this.error);

  @override
  List<Object> get props => [error];
}

class GetBusSuccess extends BusState {
  final BusModel bus;

  const GetBusSuccess(this.bus);

  @override
  List<Object> get props => [bus];
}

class GetBusError extends BusState {
  final String error;

  const GetBusError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllDriversSuccess extends BusState {
  final List<UserModel> drivers;

  const GetAllDriversSuccess(this.drivers);

  @override
  List<Object> get props => [drivers];
}

class GetAllDriversError extends BusState {
  final String error;

  const GetAllDriversError(this.error);

  @override
  List<Object> get props => [error];
}

class GetDriverSuccess extends BusState {
  final UserModel driver;

  const GetDriverSuccess(this.driver);

  @override
  List<Object> get props => [driver];
}

class GetDriverError extends BusState {
  final String error;

  const GetDriverError(this.error);

  @override
  List<Object> get props => [error];
}

class EditBusSuccess extends BusState {
  final BusModel bus;

  const EditBusSuccess(this.bus);

  @override
  List<Object> get props => [bus];
}

class EditBusError extends BusState {
  final String error;

  const EditBusError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteBusSuccess extends BusState {
  final BusModel bus;

  const DeleteBusSuccess(this.bus);

  @override
  List<Object> get props => [bus];
}

class DeleteBusError extends BusState {
  final String error;

  const DeleteBusError(this.error);

  @override
  List<Object> get props => [error];
}

class AssignUserToBusSuccess extends BusState {}

class AssignUserToBusError extends BusState {
  final String error;

  const AssignUserToBusError(this.error);

  @override
  List<Object> get props => [error];
}

class RemoveAssignUserToBusSuccess extends BusState {
  final BusModel bus;
  final UserModel driver;

  const RemoveAssignUserToBusSuccess(this.bus, this.driver);

  @override
  List<Object> get props => [bus, driver];
}

class RemoveAssignUserToBusError extends BusState {
  final String error;

  const RemoveAssignUserToBusError(this.error);

  @override
  List<Object> get props => [error];
}
