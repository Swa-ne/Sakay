import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/data/models/login.dart';
import 'package:sakay_app/data/models/sign_up.dart';
import 'package:sakay_app/data/sources/authentication/auth_repo.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

final _apiUrl = "${dotenv.env['API_URL']}/authentication";

class AuthRepoImpl extends AuthRepo {
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  @override
  Future<Map<String, dynamic>> login(LoginUserModel user) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/login"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(user.toJson()),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      _tokenController.updateAccessToken(response_body['access_token']);
      _tokenController.updateUserID(response_body['user_id']);
      _tokenController.updateFirstName(response_body['first_name']);
      _tokenController.updateLastName(response_body['last_name']);
      _tokenController.updateEmail(response_body['email']);
      _tokenController.updateProfile(response_body['profile']);
      _tokenController.updateUserType(response_body["user_type"]);

      String? cookies = response.headers['set-cookie'];
      if (cookies == null) {
        throw Exception("Server connection error");
      }

      String? refresh_token = _tokenController.extractRefreshToken(cookies);
      if (refresh_token == null) {
        throw Exception("Server connection error");
      }

      _tokenController.updateRefreshToken(refresh_token);
      return {
        "access_token": response_body['access_token'],
        "user_type": response_body['user_type']
      };
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<String> signUp(SignUpUserModel user, bool isThirdParty) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/signup"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(user.toJson()),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      if (isThirdParty) {
        _tokenController.updateAccessToken(response_body['access_token']);
        _tokenController.updateUserID(response_body['user_id']);
        _tokenController.updateFirstName(response_body['first_name']);
        _tokenController.updateLastName(response_body['last_name']);
        _tokenController.updateEmail(response_body['email']);
        _tokenController.updateProfile(response_body['profile']);
        _tokenController.updateUserType(response_body["user_type"]);

        String? cookies = response.headers['set-cookie'];
        if (cookies == null) {
          throw Exception("Internet Connection Error");
        }

        String? refresh_token = _tokenController.extractRefreshToken(cookies);
        if (refresh_token == null) {
          throw Exception("Internet Connection Error");
        }

        _tokenController.updateRefreshToken(refresh_token);
      }
      return response_body['access_token'];
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> checkEmailAvalability(String email) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-email"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'email_address': email,
        },
      ),
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception("Internal Server Error");
    }
  }

  @override
  Future<bool> checkEmailVerified(String token) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-email-verification"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409, 403].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception("Internal Server Error");
    }
  }

  @override
  Future<bool> checkUsernameAvalability(String username) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/check-username"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'username': username,
        },
      ),
    );

    final response_body = json.decode(response.body);
    if ([200, 404, 409].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> resendEmailCode(String token) async {
    var response = await http.put(
      Uri.parse("$_apiUrl/resend-verification"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
    );
    if ([200, 404, 401].contains(response.statusCode)) {
      return true;
    } else {
      throw Exception(
          "Too many requests, please wait a while before retrying.");
    }
  }

  @override
  Future<String> verifyEmail(String token, String code) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/verify-code"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: json.encode(
        {
          'code': code,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      _tokenController.updateAccessToken(response_body['access_token']);
      _tokenController.updateUserID(response_body['user_id']);

      String? cookies = response.headers['set-cookie'];
      if (cookies == null) {
        throw Exception("Server connection error");
      }

      String? refresh_token = _tokenController.extractRefreshToken(cookies);
      if (refresh_token == null) {
        throw Exception("Server connection error");
      }

      _tokenController.updateRefreshToken(refresh_token);
      return response_body['access_token'];
    } else {
      throw Exception("Incorrect Verification Code");
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse("$_apiUrl/forgot-password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(
        {
          'email_address': email,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      return response_body['token'];
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> postResetPassword(
      String token, String password, String confirmation_password) async {
    var response = await http.post(
      Uri.parse("$_apiUrl/reset-password"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token,
      },
      body: json.encode(
        {
          'password': password,
          'confirmation_password': confirmation_password,
        },
      ),
    );
    final response_body = json.decode(response.body);
    if ([200, 400, 404].contains(response.statusCode)) {
      return response_body['message'] == "Success";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<bool> logout() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    var response = await http.delete(
      Uri.parse("$_apiUrl/logout"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': access_token,
        'Cookie': 'refresh_token=$refresh_token',
      },
    );
    final response_body = json.decode(response.body);
    if (response.statusCode == 200) {
      _tokenController.removeAccessToken();
      _tokenController.removeRefreshToken();
      _tokenController.removeUserID();
      _tokenController.removeFirstName();
      _tokenController.removeLastName();
      _tokenController.removeEmail();
      _tokenController.removeProfile();
      _tokenController.removeFirstTime();
      _tokenController.removeUserType();
      return response_body['message'] == "User logged Out";
    } else {
      throw Exception(response_body['error']);
    }
  }

  @override
  Future<Map<String, dynamic>> authenticateToken() async {
    final access_token = await _tokenController.getAccessToken();
    final refresh_token = await _tokenController.getRefreshToken();
    if (refresh_token == "") {
      return {"error": "Unauthorize"};
    }
    try {
      var response = await http.get(
        Uri.parse("$_apiUrl/current-user"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': access_token,
          'Cookie': 'refresh_token=$refresh_token',
        },
      );
      final response_body = json.decode(response.body);
      if (response.statusCode == 200) {
        var newAccessToken = response.headers['authorization'];
        if (newAccessToken != null) {
          var tokenValue = newAccessToken.split(' ')[1];
          await _tokenController.updateAccessToken(tokenValue);
        }
        await _tokenController
            .updateUserType(response_body["message"]["user_type"]);
        return {
          "is_authenticated": true,
          "user_type": response_body["message"]["user_type"]
        };
      } else if (response.statusCode == 401) {
        return {"error": 'Unauthorized'};
      } else {
        return {"error": "No internet connection"};
      }
    } catch (e) {
      return {"error": "No internet connection"};
    }
  }
}
