import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/report.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/realtime/report_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/report";

class ReportRepoImpl extends ReportRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final RealtimeSocketControllerImpl _socketController =
      RealtimeSocketControllerImpl();

  @override
  Future<bool> postIncidentReport(ReportModel report) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    try {
      var response = await http.post(
        Uri.parse("$_apiUrl/create-incident-report"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
        body: json.encode(
          report.toJson(),
        ),
      );
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        _socketController.sendReport(report);
        return response_body['message'] == "Success";
      } else {
        throw Exception(response_body['message']);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> postPerformanceReport(ReportModel report) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.post(
      Uri.parse("$_apiUrl/create-performance-report"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        report.toJson(),
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _socketController.sendReport(report);
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<Map<String, dynamic>> getAllReports(String? cursor) async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      final uri = Uri.parse("$_apiUrl/get-all-report").replace(
        queryParameters: {
          if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        },
      );

      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<ReportModel> reportList =
            (response_body['message']["reports"] as List)
                .map((json) => ReportModel.fromJson(json))
                .toList();
        return {
          "reports": reportList,
          "nextCursor": response_body['message']["nextCursor"],
        };
        ;
      } else {
        throw Exception(response_body['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ReportModel> getReport(String report_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-report/$report_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return ReportModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> toggleReport(String report_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.put(
      Uri.parse("$_apiUrl/toggle-report/$report_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _socketController.toggleReport(report_id);
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }
}
