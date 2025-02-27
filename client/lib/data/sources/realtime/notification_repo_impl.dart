import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/notificaton.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/realtime/notification_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/notification";

class NotificationRepoImpl extends NotificationRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final RealtimeSocketControllerImpl _socketController =
      RealtimeSocketControllerImpl();

  @override
  Future<bool> saveNotification(
    List<File> files,
    NotificationModel notification,
  ) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/save-notification"));

    request.headers['Authorization'] = access_token;
    request.headers['Cookie'] = 'refresh_token=$refresh_token';

    for (int i = 0; i < files.length; i++) {
      File file = files[i];

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );
    }

    request.fields['headline'] = notification.headline;
    request.fields['content'] = notification.content;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      final new_notification =
          notification.copyWith(id: response_body["message"]);
      _socketController.sendNotification(new_notification);
      return true;
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<List<NotificationModel>> getAllNotifications(int page) async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response = await http
          .get(Uri.parse("$_apiUrl/get-all-notifications/$page"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      });
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<NotificationModel> notificationList =
            (response_body['message'] as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();
        return notificationList;
      } else {
        throw Exception(response_body['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<NotificationModel> getNotification(String notification_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-notification/$notification_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return NotificationModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> editNotification(
    List<File> files,
    List<String> existing_file_ids,
    NotificationModel notification,
  ) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse("$_apiUrl/edit-notification/${notification.id}"),
    );
    request.headers['Authorization'] = access_token;
    request.headers['Cookie'] = 'refresh_token=$refresh_token';

    for (int i = 0; i < files.length; i++) {
      File file = files[i];

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );
    }

    request.fields['headline'] = notification.headline;
    request.fields['content'] = notification.content;
    request.fields['existing_files'] = json.encode(existing_file_ids);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _socketController
          .sendNotification(notification); //TODO: use update instead
      return true;
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<bool> deleteNotification(String notification_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.delete(
      Uri.parse('$_apiUrl/delete-notification/$notification_id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      // _socketController.sendMessage(receiver_id, message, Notification_id); TODO: use delete
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }
}
