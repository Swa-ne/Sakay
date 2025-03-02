import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/report/report_event.dart';
import 'package:sakay_app/bloc/report/report_state.dart';
import 'package:sakay_app/data/sources/realtime/report_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final RealtimeSocketController _socketRealtimeRepo;
  final ReportRepo _reportRepo;
  bool _isSending = false;

  ReportBloc(this._reportRepo, this._socketRealtimeRepo)
      : super(ReportLoading()) {
    on<ConnectReportRealtimeEvent>((event, emit) async {
      try {
        emit(ConnectingReportRealtimeSocket());
        await _socketRealtimeRepo.passReportBloc(this);
        emit(ConnectedReportRealtimeSocket());
      } catch (e) {
        emit(const ConnectionReportRealtimeError("Connection Error"));
      }
    });
    on<PostIncidentReportEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(ReportLoading());

        try {
          final isSent = await _reportRepo.postIncidentReport(event.report);
          if (isSent) {
            emit(SaveReportSuccess());
          } else {
            emit(const SaveReportError("Failed to send incident report."));
          }
        } catch (e) {
          emit(const SaveReportError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(ReportReady());
        }
      },
    );
    on<PostPerformancetReportEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(ReportLoading());

        try {
          print("issetn runinfskindfas");
          final isSent = await _reportRepo.postPerformanceReport(event.report);
          print("issetn $isSent");

          if (isSent) {
            emit(SaveReportSuccess());
          } else {
            emit(const SaveReportError("Failed to send performance report."));
          }
        } catch (e) {
          print("issetn $e");

          emit(const SaveReportError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(ReportReady());
        }
      },
    );

    on<GetAllReportsEvent>(
      (event, emit) async {
        try {
          emit(ReportLoading());
          final reports = await _reportRepo.getAllReports(event.page);
          emit(GetAllReportsSuccess(reports));
        } catch (e) {
          emit(const GetAllReportsError("Internet Connection Error"));
        }
      },
    );

    on<GetReportEvent>(
      (event, emit) async {
        try {
          emit(ReportLoading());
          final report = await _reportRepo.getReport(event.report_id);
          emit(GetReportSuccess(report));
        } catch (e) {
          emit(const GetReportError("Internet Connection Error"));
        }
      },
    );

    on<ToggleReportEvent>(
      (event, emit) async {
        if (_isSending) return;
        _isSending = true;

        emit(ReportLoading());

        try {
          final isSent = await _reportRepo.toggleReport(event.report_id);
          if (isSent) {
            emit(ToggleReportSuccess());
          } else {
            emit(const ToggleReportError("Failed to send notification."));
          }
        } catch (e) {
          emit(const ToggleReportError("Internet Connection Error"));
        } finally {
          _isSending = false;
          emit(ReportReady());
        }
      },
    );

    on<OnReceiveToggleReportEvent>(
      (event, emit) async {
        try {
          emit(ReportLoading());
          emit(OnReceiveToggleReportSuccess(event.report));
        } catch (e) {
          emit(const OnReceiveToggleReportError("Internet Connection Error"));
        }
      },
    );
    on<OnReceiveAdminReportEvent>(
      (event, emit) async {
        try {
          emit(ReportLoading());
          emit(OnReceiveAdminReportSuccess(event.report));
        } catch (e) {
          emit(const OnReceiveAdminReportError("Internet Connection Error"));
        }
      },
    );
    on<OnReceiveAdminToggleReportEvent>(
      (event, emit) async {
        try {
          emit(ReportLoading());
          emit(OnReceiveAdminToggleReportSuccess(event.report));
        } catch (e) {
          emit(const OnReceiveAdminToggleReportError(
              "Internet Connection Error"));
        }
      },
    );
  }
}
