import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String? id;
  final String message;
  final String sender;
  final String chat_id;
  final bool is_read;
  final String created_at;
  final String updated_at;

  const MessageModel({
    this.id,
    required this.message,
    required this.sender,
    required this.chat_id,
    required this.is_read,
    required this.created_at,
    required this.updated_at,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      message: json['message'] ?? '',
      sender: json['sender_id'] ?? '',
      chat_id: json['chat_id'] ?? '',
      is_read: json['isRead'] ?? false,
      created_at: json['createdAt'] ?? "",
      updated_at: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'chat_id': chat_id,
      'isRead': is_read,
      'createdAt': created_at,
      'updatedAt': updated_at,
    };
  }

  // Add the copyWith method
  MessageModel copyWith({
    String? id,
    String? message,
    String? sender,
    String? chat_id,
    bool? is_read,
    String? created_at,
    String? updated_at,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      chat_id: chat_id ?? this.chat_id,
      is_read: is_read ?? this.is_read,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  @override
  List<Object> get props => [message, sender, chat_id, is_read];
}
