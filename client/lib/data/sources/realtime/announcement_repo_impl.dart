import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/realtime/announcement_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/announcement";

class AnnouncementRepoImpl extends AnnouncementRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final RealtimeSocketControllerImpl _socketController =
      RealtimeSocketControllerImpl();

  @override
  Future<bool> saveAnnouncement(
    List<File> files,
    AnnouncementsModel announcement,
  ) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    final request =
        http.MultipartRequest('POST', Uri.parse("$_apiUrl/save-announcement"));

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

    request.fields['headline'] = announcement.headline;
    request.fields['content'] = announcement.content;
    request.fields['audience'] = announcement.audience;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      final new_announcement =
          announcement.copyWith(id: response_body["message"]);
      _socketController.sendAnnouncement(new_announcement);
      return true;
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<List<AnnouncementsModel>> getAllAnnouncements(int page) async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      final user_type = await _tokenController.getUserType();
      try {
        var response = await http.get(
            Uri.parse("$_apiUrl/get-all-announcements/$user_type/$page"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': access_token,
              'Cookie': 'refresh_token=$refresh_token',
            });
        final response_body = json.decode(response.body);
        if (response.statusCode == 200) {
          List<AnnouncementsModel> announcementList =
              (response_body['message'] as List)
                  .map((json) => AnnouncementsModel.fromJson(json))
                  .toList();
          return announcementList;
        } else {
          throw Exception(response_body['error']);
        }
      } catch (e) {
        throw Exception(e);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<AnnouncementsModel> getAnnouncement(String announcement_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-announcement/$announcement_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return AnnouncementsModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> editAnnouncement(
    List<File> files,
    List<String> existing_file_ids,
    AnnouncementsModel announcement,
  ) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse("$_apiUrl/edit-announcement/${announcement.id}"),
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

    request.fields['headline'] = announcement.headline;
    request.fields['content'] = announcement.content;
    request.fields['audience'] = announcement.audience;
    request.fields['existing_files'] = json.encode(existing_file_ids);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _socketController
          .sendAnnouncement(announcement); //TODO: use update instead
      return true;
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<bool> deleteAnnouncement(String announcement_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.delete(
      Uri.parse('$_apiUrl/delete-announcement/$announcement_id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      // _socketController.sendMessage(receiver_id, message, Announcement_id); TODO: use delete
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }
}
