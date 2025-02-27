import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/models/user.dart';

class InboxModel extends Equatable {
  final String id;
  final UserModel user_id;
  final bool is_active;
  final MessageModel last_message;

  const InboxModel({
    required this.id,
    required this.user_id,
    required this.is_active,
    required this.last_message,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) {
    return InboxModel(
      id: json['_id'],
      user_id: UserModel.fromJson(json['user_id']),
      is_active: json['is_active'],
      last_message: MessageModel.fromJson(json['last_message']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': user_id,
      'is_active': is_active,
      'last_message': last_message,
    };
  }

  InboxModel copyWith({
    String? id,
    UserModel? user_id,
    bool? is_active,
    MessageModel? last_message,
  }) {
    return InboxModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      is_active: is_active ?? this.is_active,
      last_message: last_message ?? this.last_message,
    );
  }

  @override
  List<Object> get props => [id, user_id, is_active, last_message];
}
