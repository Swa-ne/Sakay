import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ConnectReportRealtimeEvent extends ReportEvent {}

class PostIncidentReportEvent extends ReportEvent {
  final ReportModel report;

  const PostIncidentReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class PostPerformancetReportEvent extends ReportEvent {
  final ReportModel report;

  const PostPerformancetReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class GetAllReportsEvent extends ReportEvent {
  final String cursor;

  const GetAllReportsEvent(this.cursor);

  @override
  List<Object> get props => [cursor];
}

class GetReportEvent extends ReportEvent {
  final String report_id;

  const GetReportEvent(this.report_id);

  @override
  List<Object> get props => [report_id];
}

class ToggleReportEvent extends ReportEvent {
  final String report_id;

  const ToggleReportEvent(this.report_id);

  @override
  List<Object> get props => [report_id];
}

class OnReceiveToggleReportEvent extends ReportEvent {
  final ReportModel report;

  const OnReceiveToggleReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class OnReceiveAdminReportEvent extends ReportEvent {
  final ReportModel report;

  const OnReceiveAdminReportEvent(this.report);

  @override
  List<Object> get props => [report];
}

class OnReceiveAdminToggleReportEvent extends ReportEvent {
  final ReportModel report;

  const OnReceiveAdminToggleReportEvent(this.report);

  @override
  List<Object> get props => [report];
}
