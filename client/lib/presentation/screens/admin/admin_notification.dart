// Put this in commuter and driver notifications

import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminNotification(),
    );
  }
}

class AdminNotification extends StatefulWidget {
  @override
  _AdminNotificationState createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  String _selectedItem = "Notifications";

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "New Announcement",
      "message": "Please check the latest updates.",
      "time": "10:30 AM",
      "date": "Feb 28, 2025",
      "isRead": false,
    },
    {
      "title": "User Chat",
      "message": "You have a new message from a user.",
      "time": "09:15 AM",
      "date": "Mar 1, 2025",
      "isRead": true,
    },
    {
      "title": "System Update",
      "message": "The system will undergo maintenance tonight.",
      "time": "08:00 AM",
      "date": "Jan 23, 2025",
      "isRead": false,
    },
  ];

  void _markNotificationAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF00A3FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/bus.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.white, thickness: 1),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Map";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminMap()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.map,
                        text: "Map",
                        isSelected: _selectedItem == "Map",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Surveillance";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminSurveillance()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.camera,
                        text: "Surveillance",
                        isSelected: _selectedItem == "Surveillance",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Report";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminReports()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.bar_chart,
                        text: "Report",
                        isSelected: _selectedItem == "Report",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Notifications";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminNotification()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.notifications,
                        text: "Notifications",
                        isSelected: _selectedItem == "Notifications",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Inbox";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminInbox()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.inbox,
                        text: "Inbox",
                        isSelected: _selectedItem == "Inbox",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Profile";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminProfile()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.person,
                        text: "Profile",
                        isSelected: _selectedItem == "Profile",
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  isSelected: _selectedItem == "Logout",
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A2FF),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
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
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      onTap: () {
                        _markNotificationAsRead(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: notification["isRead"]
                              ? Colors.white
                              : const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: notification["isRead"]
                                ? Colors.grey[300]!
                                : Colors.transparent,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                  color: notification["isRead"]
                                      ? Colors.grey[300]!
                                      : const Color(0xFF00A3FF),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const SizedBox(width: 11), // adjust and texts
                                  Icon(
                                    Icons.notifications,
                                    color: notification["isRead"]
                                        ? Colors.grey
                                        : const Color.fromARGB(
                                            255, 255, 255, 255),
                                  ),
                                  const SizedBox(width: 38),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification["title"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: notification["isRead"]
                                                ? Colors.grey
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification["message"],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: notification["isRead"]
                                                ? Colors.grey
                                                : const Color(0xFF888888),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${notification["time"]} • ${notification["date"]}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: notification["isRead"]
                                                ? Colors.grey
                                                : const Color(0xFF888888),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.more_horiz,
                                    color: notification["isRead"]
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: isSelected ? 40 : 50,
          width: isSelected ? 350 : 250,
          padding: isSelected
              ? const EdgeInsets.only(left: 10)
              : const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 30),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
