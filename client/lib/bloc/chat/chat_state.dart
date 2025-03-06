import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/inbox.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/models/user.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ConnectingRealtimeSocket extends ChatState {}

class ConnectedRealtimeSocket extends ChatState {}

class ChatLoading extends ChatState {}

class ChatReady extends ChatState {}

class ChatSuccess extends ChatState {}

class MessageSending extends ChatState {}

class ChatFailure extends ChatState {}

class CreateInboxSuccess extends ChatState {
  final String chat_id;

  const CreateInboxSuccess(this.chat_id);

  @override
  List<Object> get props => [chat_id];
}

class CreateInboxError extends ChatState {
  final String error;

  const CreateInboxError(this.error);

  @override
  List<Object> get props => [error];
}

class OpenInboxSuccess extends ChatState {
  final InboxModel inbox;

  const OpenInboxSuccess(this.inbox);

  @override
  List<Object> get props => [inbox];
}

class OpenInboxError extends ChatState {
  final String error;

  const OpenInboxError(this.error);

  @override
  List<Object> get props => [error];
}

class GetReceiverDetailsSuccess extends ChatState {
  final UserModel user;

  const GetReceiverDetailsSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class GetReceiverDetailsError extends ChatState {
  final String error;

  const GetReceiverDetailsError(this.error);

  @override
  List<Object> get props => [error];
}

class SaveMessageSuccess extends ChatState {
  const SaveMessageSuccess();
}

class SaveMessageError extends ChatState {
  final String error;

  const SaveMessageError(this.error);

  @override
  List<Object> get props => [error];
}

class GetMessageSuccess extends ChatState {
  final List<MessageModel> messages;

  const GetMessageSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class GetMessageError extends ChatState {
  final String error;

  const GetMessageError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveMessageSuccess extends ChatState {
  final MessageModel message;
  final UserModel user;

  const OnReceiveMessageSuccess(this.message, this.user);

  @override
  List<Object> get props => [message, user];
}

class OnReceiveMessageError extends ChatState {
  final String error;

  const OnReceiveMessageError(this.error);

  @override
  List<Object> get props => [error];
}

class GetInboxesSuccess extends ChatState {
  final List<InboxModel> inboxes;

  const GetInboxesSuccess(this.inboxes);

  @override
  List<Object> get props => [inboxes];
}

class GetInboxesError extends ChatState {
  final String error;

  const GetInboxesError(this.error);

  @override
  List<Object> get props => [error];
}

class IsReadInboxSuccess extends ChatState {
  final String chat_id;

  const IsReadInboxSuccess(this.chat_id);

  @override
  List<Object> get props => [chat_id];
}

class IsReadInboxError extends ChatState {
  final String error;

  const IsReadInboxError(this.error);

  @override
  List<Object> get props => [error];
}

class ConnectionRealtimeError extends ChatState {
  final String error;

  const ConnectionRealtimeError(this.error);

  @override
  List<Object> get props => [error];
}
