import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/notificaton.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class ConnectingNotificationRealtimeSocket extends NotificationState {}

class ConnectedNotificationRealtimeSocket extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationReady extends NotificationState {}

class SaveNotificationSuccess extends NotificationState {}

class SaveNotificationError extends NotificationState {
  final String error;

  const SaveNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

class EditNotificationSuccess extends NotificationState {}

class EditNotificationError extends NotificationState {
  final String error;

  const EditNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

class OnReceiveNotificationSuccess extends NotificationState {
  final NotificationModel notification;

  const OnReceiveNotificationSuccess(this.notification);

  @override
  List<Object> get props => [notification];
}

class OnReceiveNotificationError extends NotificationState {
  final String error;

  const OnReceiveNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

class GetNotificationSuccess extends NotificationState {
  final NotificationModel notification;

  const GetNotificationSuccess(this.notification);

  @override
  List<Object> get props => [notification];
}

class GetNotificationError extends NotificationState {
  final String error;

  const GetNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

class GetAllNotificationsSuccess extends NotificationState {
  final List<NotificationModel> notification;

  const GetAllNotificationsSuccess(this.notification);

  @override
  List<Object> get props => [notification];
}

class GetAllNotificationsError extends NotificationState {
  final String error;

  const GetAllNotificationsError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteNotificationSuccess extends NotificationState {}

class DeleteNotificationError extends NotificationState {
  final String error;

  const DeleteNotificationError(this.error);

  @override
  List<Object> get props => [error];
}

class ConnectionNotificationRealtimeError extends NotificationState {
  final String error;

  const ConnectionNotificationRealtimeError(this.error);

  @override
  List<Object> get props => [error];
}
