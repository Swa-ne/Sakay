import 'dart:io';

import 'package:sakay_app/data/models/notificaton.dart';

abstract class NotificationRepo {
  Future<bool> saveNotification(
    List<File> files,
    NotificationModel notification,
  );
  Future<List<NotificationModel>> getAllNotifications(int page);
  Future<NotificationModel> getNotification(String notification_id);
  Future<bool> editNotification(
    List<File> files,
    List<String> existing_file_ids,
    NotificationModel notification,
  );
  Future<bool> deleteNotification(String notification_id);
}
