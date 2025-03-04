import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/bus/bus_event.dart';
import 'package:sakay_app/bloc/bus/bus_state.dart';
import 'package:sakay_app/data/sources/tracker/bus_repo.dart';

class BusBloc extends Bloc<BusEvent, BusState> {
  final BusRepo _busRepo;
  bool _isSending = false;

  BusBloc(this._busRepo) : super(BusLoading()) {
    on<PostBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final id = await _busRepo.saveBus(event.bus);
          final newBus = event.bus.copyWith(id: id);
          emit(SaveBusSuccess(newBus));
        } catch (e) {
          emit(const SaveBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
    on<GetAllBusesEvent>(
      (event, emit) async {
        try {
          emit(BusLoading());
          final buss = await _busRepo.getAllBuses();
          emit(GetAllBusesSuccess(buss));
        } catch (e) {
          emit(const GetAllBusesError("Internet Connection Error"));
        }
      },
    );
    on<GetAllBusesAndDriversEvent>(
      (event, emit) async {
        try {
          emit(BusLoading());
          final buss = await _busRepo.getAllBusesAndAllDrivers();
          emit(GetAllBusesAndDriversSuccess(buss));
        } catch (e) {
          emit(const GetAllBusesAndDriversError("Internet Connection Error"));
        }
      },
    );
    on<GetBusEvent>(
      (event, emit) async {
        try {
          emit(BusLoading());
          final bus = await _busRepo.getBus(event.bus_id);
          emit(GetBusSuccess(bus));
        } catch (e) {
          emit(const GetBusError("Internet Connection Error"));
        }
      },
    );
    on<EditBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final isSent = await _busRepo.editBus(event.bus);
          if (isSent) {
            emit(EditBusSuccess(event.bus));
          } else {
            emit(const EditBusError("Failed to send incident bus."));
          }
        } catch (e) {
          emit(const EditBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
    on<DeleteBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final isSent = await _busRepo.deleteBus(event.bus.id!);
          if (isSent) {
            emit(DeleteBusSuccess(event.bus));
          } else {
            emit(const DeleteBusError("Failed to send incident bus."));
          }
        } catch (e) {
          emit(const DeleteBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
    on<GetAllDriversEvent>(
      (event, emit) async {
        try {
          emit(BusLoading());
          final drivers = await _busRepo.getAllDrivers();
          emit(GetAllDriversSuccess(drivers));
        } catch (e) {
          emit(const GetAllDriversError("Internet Connection Error"));
        }
      },
    );
    on<GetDriverEvent>(
      (event, emit) async {
        try {
          emit(BusLoading());
          final driver = await _busRepo.getDriver(event.driver_id);
          emit(GetDriverSuccess(driver));
        } catch (e) {
          emit(const GetDriverError("Internet Connection Error"));
        }
      },
    );
    on<AssignUserToBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final isSent =
              await _busRepo.assignUserToBus(event.user_id, event.bus_id);
          if (isSent) {
            emit(AssignUserToBusSuccess());
          } else {
            emit(const AssignUserToBusError("Failed to send incident bus."));
          }
        } catch (e) {
          emit(const AssignUserToBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
    on<RemoveAssignUserToBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final isSent = await _busRepo.removeAssignUserToBus(event.driver.id);
          if (isSent) {
            emit(RemoveAssignUserToBusSuccess(event.bus, event.driver));
          } else {
            emit(const RemoveAssignUserToBusError(
                "Failed to send incident bus."));
          }
        } catch (e) {
          emit(const RemoveAssignUserToBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
  }
}
