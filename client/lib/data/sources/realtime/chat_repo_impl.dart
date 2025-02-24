import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/inbox.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/realtime/chat_repo.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';

final _apiUrl = "${dotenv.env['API_URL']}/chat";

class ChatRepoImpl extends ChatRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  final RealtimeSocketControllerImpl _socketController =
      RealtimeSocketControllerImpl();

  @override
  Future<bool> saveMessage(
      String message, String chat_id, String receiver_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.post(
      Uri.parse("$_apiUrl/save-message"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'message': message,
          'chat_id': chat_id,
        },
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      _socketController.sendMessage(receiver_id, message, chat_id);
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<String> createPrivateInbox() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.post(
      Uri.parse("$_apiUrl/create-private-inbox"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'];
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<String> openCreatedInboxContentByChatID(String chat_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.get(
      Uri.parse("$_apiUrl/open-inbox-details/$chat_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body["message"];
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<List<MessageModel>> getMessage(String chat_id, int page) async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response = await http
          .get(Uri.parse("$_apiUrl/get-messages/$chat_id/$page"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      });
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<MessageModel> messageList = (response_body['message'] as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
        return messageList;
      } else {
        throw Exception(response_body['message']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<InboxModel> openInbox() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/open-inbox"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return InboxModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<List<InboxModel>> getAllInboxes(int page) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-all-inbox/$page"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      List<InboxModel> inboxList = (response_body['message'] as List)
          .map((json) => InboxModel.fromJson(json))
          .toList();

      return inboxList;
    } else {
      throw Exception(response_body['message']);
    }
  }
}
