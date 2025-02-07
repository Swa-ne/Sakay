class LoginUserModel {
  final String email;
  final String password;

  LoginUserModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email_address': email,
      'password': password,
    };
  }
}
