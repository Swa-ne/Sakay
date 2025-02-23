import 'package:flutter/material.dart';

class AdminNotification extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminNotification({super.key, required this.openDrawer});

  @override
  _AdminNotificationState createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu,
                              color: Colors.black, size: 25),
                          onPressed: () {
                            widget.openDrawer();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Notification',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.notifications, color: Color(0xFF00A3FF)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Driver Verification Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See Details...',
                                  style: TextStyle(color: Color(0xFF888888)),
                                )
                              ],
                            ),
                          ),
                          Icon(Icons.more_horiz, color: Colors.black),
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
