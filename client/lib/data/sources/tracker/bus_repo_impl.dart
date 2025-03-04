import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/bus.dart';
import 'package:sakay_app/data/models/user.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/data/sources/tracker/bus_repo.dart';

final _apiUrl = "${dotenv.env['API_URL']}/bus";

class BusRepoImpl extends BusRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<String> saveBus(BusModel bus) async {
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
      return response_body['message'];
    } else {
      throw Exception(response_body['error']);
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
        return BusList;
      } else {
        throw Exception(response_body['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<BusModel>> getAllBusesAndAllDrivers() async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response = await http
          .get(Uri.parse("$_apiUrl/get-busses-and-all-drivers"), headers: {
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
  Future<List<UserModel>> getAllDrivers() async {
    try {
      final access_token = await _tokenController.getAccessToken();
      final refresh_token = await _tokenController.getRefreshToken();
      var response =
          await http.get(Uri.parse("$_apiUrl/get-drivers"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      });
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        List<UserModel> driversList = (response_body['message'] as List)
            .map((json) => UserModel.fromJson(json))
            .toList();
        return driversList;
      } else {
        throw Exception(response_body['error']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserModel> getDriver(String user_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/get-driver/$user_id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(response_body["message"]);
    } else {
      throw Exception(response_body['error']);
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
  Future<bool> removeAssignUserToBus(String user_id) async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();

    var response = await http.delete(
      Uri.parse("$_apiUrl/remove-assign-driver"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
      body: json.encode(
        {
          'user_id': user_id,
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
