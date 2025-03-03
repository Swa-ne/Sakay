import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/tracker/bus_repo.dart';

final _apiUrl = "${dotenv.env['API_URL']}/bus";

class BusRepoImpl extends BusRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<bool> saveBus(BusModel bus) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.post(
      Uri.parse("$_apiUrl/create-bus"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        bus.toJson(),
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<List<BusModel>> getAllBuses() async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response = await http.get(Uri.parse("$_apiUrl/get-busses"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      });
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<BusModel> BusList = (response_body['message'] as List)
            .map((json) => BusModel.fromJson(json))
            .toList();
        print(
            " fashfjkh sajkdfh dsaf ${BusList[0].current_driver?.first_name}");
        return BusList;
      } else {
        throw Exception(response_body['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<BusModel> getBus(String bus_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-bus/$bus_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return BusModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> editBus(BusModel bus) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.put(
      Uri.parse("$_apiUrl/edit-bus/${bus.id}"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        bus.toJson(),
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<bool> deleteBus(String bus_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    final response = await http.delete(
      Uri.parse('$_apiUrl/delete/$bus_id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<bool> assignUserToBus(String user_id, String bus_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.post(
      Uri.parse("$_apiUrl/assign-driver"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'user_id': user_id,
          'bus_id': bus_id,
        },
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }

  @override
  Future<bool> reassignUserToBus(String user_id, String bus_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.put(
      Uri.parse("$_apiUrl/reassign-driver"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'user_id': user_id,
          'bus_id': bus_id,
        },
      ),
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['message']);
    }
  }
}
