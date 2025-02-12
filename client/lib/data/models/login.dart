class LoginUserModel {
  final String user_identifier;
  final String password;

  LoginUserModel({
    required this.user_identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_identifier': user_identifier,
      'password': password,
    };
  }
}
