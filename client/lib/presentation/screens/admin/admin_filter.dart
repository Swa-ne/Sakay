import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdminNotification(),
    );
  }
}

class AdminNotification extends StatefulWidget {
  const AdminNotification({Key? key}) : super(key: key);

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  String? selectedFilter;
  
  // Sample notification data
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "System Outage",
      message: "Main server is down. Engineers are working to resolve the issue.",
      type: "Incident",
      time: "2 hours ago",
      isRead: false,
    ),
    NotificationItem(
      title: "Performance Alert",
      message: "Database response time has increased by 30%.",
      type: "Performance",
      time: "3 hours ago",
      isRead: true,
    ),
    NotificationItem(
      title: "Scheduled Maintenance",
      message: "System will be down for maintenance on Sunday from 2AM to 4AM.",
      type: "Maintenance",
      time: "1 day ago",
      isRead: false,
    ),
    NotificationItem(
      title: "Security Breach Attempt",
      message: "Multiple failed login attempts detected from unknown IP.",
      type: "Incident",
      time: "2 days ago",
      isRead: true,
    ),
    NotificationItem(
      title: "CPU Usage Spike",
      message: "Application server CPU usage reached 95% for 10 minutes.",
      type: "Performance",
      time: "3 days ago",
      isRead: false,
    ),
    NotificationItem(
      title: "Database Upgrade",
      message: "Database will be upgraded to the latest version next week.",
      type: "Maintenance",
      time: "4 days ago",
      isRead: true,
    ),
    NotificationItem(
      title: "Network Latency",
      message: "Increased network latency detected in East region.",
      type: "Performance",
      time: "5 days ago",
      isRead: false,
    ),
  ];

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == null) {
      return notifications;
    }
    return notifications.where((notification) => notification.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Notifications'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter notifications',
            onSelected: (String value) {
              setState(() {
                selectedFilter = value == 'All' ? null : value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('All Notifications'),
              ),
              const PopupMenuItem<String>(
                value: 'Incident',
                child: Text('Incident Reports'),
              ),
              const PopupMenuItem<String>(
                value: 'Performance',
                child: Text('Performance Reports'),
              ),
              const PopupMenuItem<String>(
                value: 'Maintenance',
                child: Text('Maintenance Reports'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedFilter != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Filtered by: $selectedFilter',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                    child: const Text('Clear Filter'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: filteredNotifications.isEmpty
                ? const Center(
                    child: Text('No notifications found'),
                  )
                : ListView.separated(
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return NotificationTile(notification: notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(notification.type),
        child: Icon(
          _getTypeIcon(notification.type),
          color: Colors.white,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(notification.message),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notification.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTypeColor(notification.type),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                notification.time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        // Handle notification tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification: ${notification.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Incident':
        return Colors.red;
      case 'Performance':
        return Colors.orange;
      case 'Maintenance':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Incident':
        return Icons.warning;
      case 'Performance':
        return Icons.speed;
      case 'Maintenance':
        return Icons.build;
      default:
        return Icons.notifications;
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String type;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });
}

