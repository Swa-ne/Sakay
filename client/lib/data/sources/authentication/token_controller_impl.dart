import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sakay_app/data/sources/authentication/token_controller.dart';

class TokenControllerImpl extends TokenController {
  static final TokenControllerImpl _instance = TokenControllerImpl._internal();

  factory TokenControllerImpl() {
    return _instance;
  }

  TokenControllerImpl._internal();
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> updateRefreshToken(String token) async {
    await _storage.write(key: "Refresh Token", value: token);
  }

  @override
  Future<void> updateAccessToken(String token) async {
    await _storage.write(key: "Access Token", value: token);
  }

  @override
  Future<void> updateUserID(String user_id) async {
    await _storage.write(key: "User ID", value: user_id);
  }

  @override
  Future<void> updateFirstName(String first_name) async {
    await _storage.write(key: "First Name", value: first_name);
  }

  @override
  Future<void> updateLastName(String last_name) async {
    await _storage.write(key: "Last Name", value: last_name);
  }

  @override
  Future<void> updateEmail(String email) async {
    await _storage.write(key: "Email", value: email);
  }

  @override
  Future<void> updateProfile(String profile) async {
    await _storage.write(key: "Profile", value: profile);
  }

  @override
  Future<void> updateFirstTime(String toggle) async {
    await _storage.write(key: "First Time", value: toggle);
  }

  @override
  Future<void> removeRefreshToken() async {
    await _storage.delete(key: "Refresh Token");
  }

  @override
  Future<void> removeAccessToken() async {
    await _storage.delete(key: "Access Token");
  }

  @override
  Future<void> removeUserID() async {
    await _storage.delete(key: "User ID");
  }

  @override
  Future<void> removeFirstName() async {
    await _storage.delete(key: "First Name");
  }

  @override
  Future<void> removeLastName() async {
    await _storage.delete(key: "Last Name");
  }

  @override
  Future<void> removeEmail() async {
    await _storage.delete(key: "Email");
  }

  @override
  Future<void> removeProfile() async {
    await _storage.delete(key: "Profile");
  }

  @override
  Future<void> removeFirstTime() async {
    await _storage.delete(key: "First Time");
  }

  @override
  Future<String> getRefreshToken() async {
    return await _storage.read(key: "Refresh Token") ?? "";
  }

  @override
  Future<String> getAccessToken() async {
    return await _storage.read(key: "Access Token") ?? "";
  }

  @override
  Future<String> getUserID() async {
    return await _storage.read(key: "User ID") ?? "";
  }

  @override
  Future<String> getFirstName() async {
    return await _storage.read(key: "First Name") ?? "";
  }

  @override
  Future<String> getLastName() async {
    return await _storage.read(key: "Last Name") ?? "";
  }

  @override
  Future<String> getEmail() async {
    return await _storage.read(key: "Email") ?? "";
  }

  @override
  Future<String> getProfile() async {
    return await _storage.read(key: "Profile") ?? "";
  }

  @override
  Future<String> getFirstTime() async {
    return await _storage.read(key: "First Time") ?? "";
  }

  @override
  String? extractRefreshToken(String refresh_token) {
    if (refresh_token.contains('refresh_token=')) {
      final refreshTokenMatch =
          RegExp(r'refresh_token=([^;]+)').firstMatch(refresh_token);
      return refreshTokenMatch?.group(1);
    }

    return null;
  }
}
