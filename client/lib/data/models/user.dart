import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String full_name;
  final String email;
  final String profile;

  const UserModel({
    required this.id,
    required this.full_name,
    required this.email,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['_id'],
      full_name: data['full_name'],
      email: data['personal_email'],
      profile: data['profile_picture_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': full_name,
      'personal_email': email,
      'profile_picture_url': profile,
    };
  }

  @override
  List<Object> get props => [id, full_name, email, profile];
}
