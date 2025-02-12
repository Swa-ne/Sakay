import 'package:sakay_app/data/models/login.dart';
import 'package:sakay_app/data/models/sign_up.dart';

abstract class AuthRepo {
  Future<Map<String, dynamic>> login(LoginUserModel user);
  Future<String> signUp(SignUpUserModel user, bool isThirdParty);
  Future<bool> checkEmailAvalability(String email);
  Future<bool> checkUsernameAvalability(String username);
  Future<bool> checkEmailVerified(String token);
  Future<bool> resendEmailCode(String token);
  Future<String> verifyEmail(String token, String code);
  Future<String> forgotPassword(String email);
  Future<bool> postResetPassword(
      String token, String password, String confirmation_password);
  Future<bool> logout();
  Future<Map<String, dynamic>> authenticateToken();
}
