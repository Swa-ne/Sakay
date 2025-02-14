abstract class TokenController {
  Future<void> updateRefreshToken(String token);
  Future<void> updateAccessToken(String token);
  Future<void> updateUserID(String user_id);
  Future<void> removeRefreshToken();
  Future<void> removeAccessToken();
  Future<void> removeUserID();
  Future<String> getRefreshToken();
  Future<String> getAccessToken();
  Future<String> getUserID();
  String? extractRefreshToken(String refresh_token);
}
