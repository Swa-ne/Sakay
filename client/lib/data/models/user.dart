import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String profile;

  const UserModel({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email_address'],
      profile: json['profile_picture_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'first_name': first_name,
      'last_name': last_name,
      'personal_email': email,
      'profile_picture_url': profile,
    };
  }

  UserModel copyWith({
    String? id,
    String? first_name,
    String? last_name,
    String? email,
    String? profile,
  }) {
    return UserModel(
      id: id ?? this.id,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      email: email ?? this.email,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object> get props => [id, first_name, last_name, email, profile];
}
