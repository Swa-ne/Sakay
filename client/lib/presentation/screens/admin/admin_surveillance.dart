import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AdminSurveillance(),
      theme: ThemeData(
        primaryColor: const Color(0xFF00A3FF),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class AdminSurveillance extends StatefulWidget {
  const AdminSurveillance({super.key});

  @override
  State<AdminSurveillance> createState() => _AdminSurveillanceState();
}

class _AdminSurveillanceState extends State<AdminSurveillance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedItem = "Surveillance";

  void _openDrawer() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_scaffoldKey.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
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
                      _buildDrawerItem(
                        icon: Icons.map,
                        text: "Map",
                        isSelected: _selectedItem == "Map",
                        onTap: () {
                          setState(() => _selectedItem = "Map");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminMap(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.camera,
                        text: "Surveillance",
                        isSelected: _selectedItem == "Surveillance",
                        onTap: () {
                          setState(() => _selectedItem = "Surveillance");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminSurveillance(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.bar_chart,
                        text: "Report",
                        isSelected: _selectedItem == "Report",
                        onTap: () {
                          setState(() => _selectedItem = "Report");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminReports(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.notifications,
                        text: "Notifications",
                        isSelected: _selectedItem == "Notifications",
                        onTap: () {
                          setState(() => _selectedItem = "Notifications");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminNotification(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.inbox,
                        text: "Inbox",
                        isSelected: _selectedItem == "Inbox",
                        onTap: () {
                          setState(() => _selectedItem = "Inbox");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminInbox(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.person,
                        text: "Profile",
                        isSelected: _selectedItem == "Profile",
                        onTap: () {
                          setState(() => _selectedItem = "Profile");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminProfile(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDrawerItem(
                    icon: Icons.logout,
                    text: "Logout",
                    isSelected: false,
                    onTap: () {
                      // Implement logout functionality
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xFF00A3FF),
          elevation: 0,
          title: const Text(
            'Surveillance',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: _openDrawer,
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search unit",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 11.0, left: 16.0),
              child: Row(
                children: [
                  Text(
                    "Units",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: const [
                  UnitCard(
                    unitName: "UNIT-17A",
                    name: "Bartoleme Di Magiba",
                    contactNumber: "+63 912 345 6789",
                    distance: "2 km",
                    duration: "2h 46min",
                  ),
                  UnitCard(
                    unitName: "UNIT-07U",
                    name: "Artullo Consuelo",
                    contactNumber: "+63 987 654 3210",
                    distance: "2 km",
                    duration: "2h 46min",
                  ),
                  UnitCard(
                    unitName: "UNIT-84C",
                    name: "Bernard De Jesus",
                    contactNumber: "+63 923 456 7890",
                    distance: "2 km",
                    duration: "2h 46min",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DrawerItem(
        icon: icon,
        text: text,
        isSelected: isSelected,
      ),
    );
  }
}

class UnitCard extends StatelessWidget {
  final String unitName;
  final String name;
  final String contactNumber;
  final String distance;
  final String duration;

  const UnitCard({
    super.key,
    required this.unitName,
    required this.name,
    required this.contactNumber,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00A2FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Image.asset(
                    'assets/bus.png',
                    width: 45,
                    height: 45,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unitName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 68, 68, 68),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contactNumber,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.local_parking,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: Text(
                            distance,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.lightBlue,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
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