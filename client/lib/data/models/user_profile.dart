class UserProfileModel {
  final String? id;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String username;
  final String full_name;
  final String profile_picture_url;
  final String personal_email;
  final DateTime birthday;

  UserProfileModel({
    this.id,
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.username,
    required this.full_name,
    required this.profile_picture_url,
    required this.personal_email,
    required this.birthday,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? "",
      first_name: json['first_name'],
      middle_name: json['middle_name'] ?? '',
      last_name: json['last_name'] ?? "",
      username: json['username'] ?? "",
      full_name: json['full_name'],
      profile_picture_url: json['profile_picture_url'] ?? '',
      personal_email: json['personal_email'],
      birthday: DateTime.parse(json['birthday']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': first_name,
      'middle_name': middle_name,
      'last_name': last_name,
      'username': username,
      'full_name': full_name,
      'profile_picture_url': profile_picture_url,
      'personal_email': personal_email,
      'birthday': birthday.toIso8601String(),
    };
  }
}
