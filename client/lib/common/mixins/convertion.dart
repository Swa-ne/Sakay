import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin Convertion {
  String formatDateTime(String dtString) {
    DateTime dt = DateTime.parse(dtString).toLocal();
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

    if (dt.isAfter(startOfWeek)) {
      return DateFormat('E h:mm a').format(dt); // Format: Fri 11:00 PM
    } else {
      return DateFormat('MMM d, y, h:mm a')
          .format(dt); // Format: Jan 13, 2025, 11:00 PM
    }
  }

  String formatToDate(String dtString) {
    DateTime dt = DateTime.parse(dtString).toLocal();

    return DateFormat('MMM d, y').format(dt); // Format: Jan 13, 2025, 11:00 PM
  }

  String formatToTime(String dtString) {
    DateTime dt = DateTime.parse(dtString).toLocal();

    return DateFormat('h:mm a').format(dt); // Format: Jan 13, 2025, 11:00 PM
  }

  String formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      return "${dateTime.month}/${dateTime.day}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    }
  }

  String timeAgo(String dtString) {
    DateTime dt = DateTime.parse(dtString).toLocal();
    Duration diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 30) {
      int weeks = (diff.inDays / 7).floor();
      return "${weeks} week${weeks > 1 ? 's' : ''} ago";
    } else if (diff.inDays < 365) {
      int months = (diff.inDays / 30).floor();
      return "${months} month${months > 1 ? 's' : ''} ago";
    } else {
      int years = (diff.inDays / 365).floor();
      return "${years} year${years > 1 ? 's' : ''} ago";
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String period = time.hour < 12 ? 'AM' : 'PM';

    return '$hour:$minute$period';
  }
}
