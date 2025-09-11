import 'package:sakay_app/data/models/report.dart';

abstract class ReportRepo {
  Future<bool> postIncidentReport(ReportModel report);
  Future<bool> postPerformanceReport(ReportModel report);
  Future<Map<String, dynamic>> getAllReports(String? cursor);
  Future<ReportModel> getReport(String report_id);
  Future<bool> toggleReport(String report_id);
}
