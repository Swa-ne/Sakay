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
          final isSent = await _busRepo.saveBus(event.bus);
          if (isSent) {
            emit(SaveBusSuccess());
          } else {
            emit(const SaveBusError("Failed to send incident bus."));
          }
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
            emit(EditBusSuccess());
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
    on<ReassignUserToBusEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(BusLoading());

        try {
          final isSent =
              await _busRepo.reassignUserToBus(event.user_id, event.bus_id);
          if (isSent) {
            emit(ReassignUserToBusSuccess());
          } else {
            emit(const ReassignUserToBusError("Failed to send incident bus."));
          }
        } catch (e) {
          emit(const ReassignUserToBusError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(BusReady());
        }
      },
    );
  }
}
