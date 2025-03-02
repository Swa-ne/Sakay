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
}
