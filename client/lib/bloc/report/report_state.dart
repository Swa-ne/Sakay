import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ConnectingReportRealtimeSocket extends ReportState {}

class ConnectedReportRealtimeSocket extends ReportState {}

class ConnectionReportRealtimeError extends ReportState {
  final String error;

  const ConnectionReportRealtimeError(this.error);

  @override
  List<Object> get props => [error];
}

class ReportLoading extends ReportState {}

class ReportReady extends ReportState {}

class SaveReportSuccess extends ReportState {}

class SaveReportError extends ReportState {
  final String error;

  const SaveReportError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllReportsSuccess extends ReportState {
  final List<ReportModel> reports;
  final String cursor;

  const GetAllReportsSuccess(this.reports, this.cursor);

  @override
  List<Object> get props => [reports, cursor];
}

class GetAllReportsError extends ReportState {
  final String error;

  const GetAllReportsError(this.error);

  @override
  List<Object> get props => [error];
}

class GetReportSuccess extends ReportState {
  final ReportModel reports;

  const GetReportSuccess(this.reports);

  @override
  List<Object> get props => [reports];
}

class GetReportError extends ReportState {
  final String error;

  const GetReportError(this.error);

  @override
  List<Object> get props => [error];
}

class ToggleReportSuccess extends ReportState {}

class ToggleReportError extends ReportState {
  final String error;

  const ToggleReportError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveToggleReportSuccess extends ReportState {
  final ReportModel report;

  const OnReceiveToggleReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}

class OnReceiveToggleReportError extends ReportState {
  final String error;

  const OnReceiveToggleReportError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveAdminReportSuccess extends ReportState {
  final ReportModel report;

  const OnReceiveAdminReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}

class OnReceiveAdminReportError extends ReportState {
  final String error;

  const OnReceiveAdminReportError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveAdminToggleReportSuccess extends ReportState {
  final ReportModel report;

  const OnReceiveAdminToggleReportSuccess(this.report);

  @override
  List<Object> get props => [report];
}

class OnReceiveAdminToggleReportError extends ReportState {
  final String error;

  const OnReceiveAdminToggleReportError(this.error);

  @override
  List<Object> get props => [error];
}
