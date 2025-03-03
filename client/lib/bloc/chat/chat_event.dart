import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/user.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ConnectRealtimeEvent extends ChatEvent {}

class ConnectAdminEvent extends ChatEvent {}

class CreateInboxEvent extends ChatEvent {}

class SaveMessageEvent extends ChatEvent {
  final String message;
  final String chat_id;
  final String receiver_id;

  const SaveMessageEvent(this.message, this.chat_id, this.receiver_id);

  @override
  List<Object> get props => [message, chat_id, receiver_id];
}

class GetMessageEvent extends ChatEvent {
  final String chat_id;
  final int page;

  const GetMessageEvent(this.chat_id, this.page);

  @override
  List<Object> get props => [chat_id, page];
}

class GetReceiverDetailsEvent extends ChatEvent {
  final String chat_id;

  const GetReceiverDetailsEvent(this.chat_id);

  @override
  List<Object> get props => [chat_id];
}

class OpenInboxEvent extends ChatEvent {}

class OnReceiveMessageEvent extends ChatEvent {
  final String chat_id;
  final String msg;
  final String sender_id;
  final UserModel user;

  const OnReceiveMessageEvent(
    this.chat_id,
    this.msg,
    this.sender_id,
    this.user,
  );

  @override
  List<Object> get props => [chat_id, msg, sender_id, user];
}

class GetInboxesEvent extends ChatEvent {
  final int page;

  const GetInboxesEvent(this.page);

  @override
  List<Object> get props => [page];
}

class IsReadInboxesEvent extends ChatEvent {
  final String chat_id;

  const IsReadInboxesEvent(this.chat_id);

  @override
  List<Object> get props => [chat_id];
}
