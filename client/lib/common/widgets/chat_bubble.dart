import 'package:flutter/material.dart';

Widget chatBubble(String message, bool isMe, String createdAt, {required bool isDark}) {
  final Color bubbleColor = isMe
      ? (isDark ? Colors.blue[700]! : Colors.blue[200]!)
      : (isDark ? Colors.grey[800]! : Colors.grey[300]!);

  final Color textColor = isDark ? Colors.white : Colors.black;

  return Column(
    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 5),
            Text(
              createdAt,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
