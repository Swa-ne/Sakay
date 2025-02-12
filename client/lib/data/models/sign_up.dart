class SignUpUserModel {
  final String? first_name;
  final String? middle_name;
  final String? last_name;
  final String? email_address;
  final String? password_hash;
  final String? confirmation_password;
  final String? phone_number;
  final String? birthday;
  final String? user_type;
  final bool? valid_email_address;

  SignUpUserModel({
    this.first_name,
    this.middle_name,
    this.last_name,
    this.email_address,
    this.password_hash,
    this.confirmation_password,
    this.phone_number,
    this.birthday,
    this.user_type,
    this.valid_email_address = false,
  });

  SignUpUserModel copyWith({
    String? first_name,
    String? middle_name,
    String? last_name,
    String? email_address,
    String? password_hash,
    String? confirmation_password,
    String? phone_number,
    String? birthday,
    String? user_type,
    bool? valid_email_address,
  }) {
    return SignUpUserModel(
      first_name: first_name ?? this.first_name,
      middle_name: middle_name ?? this.middle_name,
      last_name: last_name ?? this.last_name,
      email_address: email_address ?? this.email_address,
      password_hash: password_hash ?? this.password_hash,
      confirmation_password:
          confirmation_password ?? this.confirmation_password,
      phone_number: phone_number ?? this.phone_number,
      birthday: birthday ?? this.birthday,
      user_type: user_type ?? this.user_type,
      valid_email_address: valid_email_address ?? this.valid_email_address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'middle_name': middle_name,
      'last_name': last_name,
      'email_address': email_address,
      'password_hash': password_hash,
      'confirmation_password': confirmation_password,
      'phone_number': phone_number,
      'birthday': birthday,
      'user_type': user_type,
      'valid_email_address': valid_email_address,
    };
  }
}
