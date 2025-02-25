import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/notificaton.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class ConnectNotificationRealtimeEvent extends NotificationEvent {}

class SaveNotificationEvent extends NotificationEvent {
  final List<File> files;
  final NotificationModel notification;

  const SaveNotificationEvent(this.files, this.notification);

  @override
  List<Object> get props => [files, notification];
}

class GetAllNotificationsEvent extends NotificationEvent {
  final int page;

  const GetAllNotificationsEvent(this.page);

  @override
  List<Object> get props => [page];
}

class GetNotificationEvent extends NotificationEvent {
  final String notification_id;

  const GetNotificationEvent(this.notification_id);

  @override
  List<Object> get props => [notification_id];
}

class EditNotificationEvent extends NotificationEvent {
  final List<File> files;
  final NotificationModel notification;

  const EditNotificationEvent(this.files, this.notification);

  @override
  List<Object> get props => [files, notification];
}

class DeleteNotificationEvent extends NotificationEvent {
  final String notification_id;

  const DeleteNotificationEvent(this.notification_id);

  @override
  List<Object> get props => [notification_id];
}

class OnReceiveNotificationEvent extends NotificationEvent {
  final NotificationModel notification;

  const OnReceiveNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}
