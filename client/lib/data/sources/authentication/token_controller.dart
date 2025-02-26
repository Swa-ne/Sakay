abstract class TokenController {
  Future<void> updateRefreshToken(String token);
  Future<void> updateAccessToken(String token);
  Future<void> updateUserID(String user_id);
  Future<void> updateFirstName(String first_name);
  Future<void> updateLastName(String last_name);
  Future<void> updateEmail(String email);
  Future<void> updateProfile(String profile);
  Future<void> removeRefreshToken();
  Future<void> removeAccessToken();
  Future<void> removeUserID();
  Future<void> removeFirstName();
  Future<void> removeLastName();
  Future<void> removeEmail();
  Future<void> removeProfile();
  Future<String> getRefreshToken();
  Future<String> getAccessToken();
  Future<String> getUserID();
  Future<String> getFirstName();
  Future<String> getLastName();
  Future<String> getEmail();
  Future<String> getProfile();
  String? extractRefreshToken(String refresh_token);
}
