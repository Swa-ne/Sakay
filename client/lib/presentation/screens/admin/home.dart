import 'package:flutter/material.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/drawer_item.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Tracker {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminMap(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminSurveillance(
          openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminReports(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminNotification(
          openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminInbox(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminProfile(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF00A3FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sakay Administrative",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 0;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.map,
                        text: "Map",
                        isSelected: _selectedItem == 0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 1;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.camera,
                        text: "Surveillance",
                        isSelected: _selectedItem == 1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 2;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.bar_chart,
                        text: "Report",
                        isSelected: _selectedItem == 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 3;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.notifications,
                        text: "Notifications",
                        isSelected: _selectedItem == 3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 4;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.inbox,
                        text: "Inbox",
                        isSelected: _selectedItem == 4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = 5;
                        });
                      },
                      child: DrawerItem(
                        icon: Icons.person,
                        text: "Profile",
                        isSelected: _selectedItem == 5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  isSelected: false,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      body: pages[_selectedItem],
    );
  }
}
