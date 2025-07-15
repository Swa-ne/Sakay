import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String? id;
  final String message;
  final String sender;
  final String chat_id;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  const MessageModel({
    this.id,
    required this.message,
    required this.sender,
    required this.chat_id,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      message: json['message'] ?? '',
      sender: json['sender_id'] ?? '',
      chat_id: json['chat_id'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender,
      'chat_id': chat_id,
      'isRead': isRead,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Add the copyWith method
  MessageModel copyWith({
    String? id,
    String? message,
    String? sender,
    String? chat_id,
    bool? isRead,
    String? createdAt,
    String? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      chat_id: chat_id ?? this.chat_id,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object> get props => [message, sender, chat_id, isRead];
}
