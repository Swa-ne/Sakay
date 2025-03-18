import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

class AdminMap extends StatefulWidget {
  const AdminMap({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<AdminMap> {
  String _selectedItem = "Map";

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
                    const SizedBox(height: 10),
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
                        Navigator.push(
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
                        Navigator.push(
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
                        Navigator.push(
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
                        Navigator.push(
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
                        Navigator.push(
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
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey),
            ),
            child: const ClipRRect(
              child: Center(
                child: MyMapWidget(),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu,
                        color: Colors.black, size: 24),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 70,
            right: 20,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 2),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                ),
              ),
            ),
          ),
        ],
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
