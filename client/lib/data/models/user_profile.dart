class UserProfileModel {
  final String? id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String username;
  final String fullName;
  final String profilePictureUrl;
  final String personalEmail;
  final DateTime birthday;

  UserProfileModel({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.username,
    required this.fullName,
    required this.profilePictureUrl,
    required this.personalEmail,
    required this.birthday,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] ?? "",
      firstName: json['first_name'],
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? "",
      username: json['username'] ?? "",
      fullName: json['full_name'],
      profilePictureUrl: json['profile_picture_url'] ?? '',
      personalEmail: json['personal_email'],
      birthday: DateTime.parse(json['birthday']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'username': username,
      'full_name': fullName,
      'profile_picture_url': profilePictureUrl,
      'personal_email': personalEmail,
      'birthday': birthday.toIso8601String(),
    };
  }
}
