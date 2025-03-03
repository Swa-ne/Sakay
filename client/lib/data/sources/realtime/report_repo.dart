import 'package:sakay_app/data/models/report.dart';

abstract class ReportRepo {
  Future<bool> postIncidentReport(ReportModel report);
  Future<bool> postPerformanceReport(ReportModel report);
  Future<List<ReportModel>> getAllReports(int page);
  Future<ReportModel> getReport(String report_id);
  Future<bool> toggleReport(String report_id);
}
