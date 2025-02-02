import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/bloc/tracker/tracker_state.dart';
import 'package:sakay_app/data/sources/tracker/socket_controller.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final SocketController _socketRepo;

  TrackerBloc(this._socketRepo) : super(ConnectingSocket()) {
    on<ConnectEvent>((event, emit) {
      try {
        emit(ConnectingSocket());
        _socketRepo.connect();
        emit(ConnectedSocket());
      } catch (e) {
        emit(const ConnectionError("Connection Error"));
      }
    });
    on<StartTrackMyVehicleEvent>(
      (event, emit) async {
        try {
          emit(TrackMyVehicleInitializing());
          _socketRepo.trackMyVehicle();
          emit(TrackMyVehicleStarted());
        } catch (e) {
          emit(const ConnectionError("Connection Error"));
        }
      },
    );
    on<StopTrackMyVehicleEvent>(
      (event, emit) async {
        try {
          emit(TrackMyVehicleInitializing());
          _socketRepo.stopTrackMyVehicle();
          emit(TrackMyVehicleStopped());
        } catch (e) {
          emit(const ConnectionError("Connection Error"));
        }
      },
    );
  }
}
