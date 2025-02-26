import 'package:flutter/material.dart';
import 'package:sakay_app/data/models/notificaton.dart';

// TODO: add refresh callback
class NotificationsScreen extends StatefulWidget {
  final List<NotificationModel> notifications;
  final ScrollController scrollNotificationController;
  final bool isLoadingNotification;

  const NotificationsScreen({
    super.key,
    required this.notifications,
    required this.scrollNotificationController,
    required this.isLoadingNotification,
  });

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: widget.notifications.isEmpty
                    ? const Center(
                        child: Text("No notifications yet"),
                      )
                    : ListView.builder(
                        itemCount: widget.notifications.length,
                        controller: widget.scrollNotificationController,
                        itemBuilder: (context, index) {
                          final notification = widget.notifications[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.notifications,
                                    color: Color(0xFF00A3FF)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.headline,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        notification.content,
                                        style: const TextStyle(
                                            color: Color(0xFF888888)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                                const Icon(Icons.more_horiz,
                                    color: Colors.black),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;

  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}
