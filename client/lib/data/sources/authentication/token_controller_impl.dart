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
  String? extractRefreshToken(String refresh_token) {
    if (refresh_token.contains('refresh_token=')) {
      final refreshTokenMatch =
          RegExp(r'refresh_token=([^;]+)').firstMatch(refresh_token);
      return refreshTokenMatch?.group(1);
    }

    return null;
  }
}
