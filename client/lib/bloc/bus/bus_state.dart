import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/bus.dart';

abstract class BusState extends Equatable {
  const BusState();

  @override
  List<Object> get props => [];
}

class BusLoading extends BusState {}

class BusReady extends BusState {}

class SaveBusSuccess extends BusState {}

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

class EditBusSuccess extends BusState {}

class EditBusError extends BusState {
  final String error;

  const EditBusError(this.error);

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

class ReassignUserToBusSuccess extends BusState {}

class ReassignUserToBusError extends BusState {
  final String error;

  const ReassignUserToBusError(this.error);

  @override
  List<Object> get props => [error];
}
