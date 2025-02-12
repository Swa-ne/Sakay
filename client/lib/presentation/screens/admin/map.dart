import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const DrawerItem(icon: Icons.map, text: "Surveillance"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/map');
                      },
                      child: const DrawerItem(icon: Icons.map, text: "Map"),
                    ),
                    const DrawerItem(icon: Icons.bar_chart, text: "Report"),
                    const DrawerItem(
                        icon: Icons.notifications, text: "Notifications"),
                    const DrawerItem(icon: Icons.inbox, text: "Inbox"),
                    const DrawerItem(icon: Icons.settings, text: "Settings"),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: DrawerItem(icon: Icons.logout, text: "Logout"),
              ),
              const SizedBox(height: 20),
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
            left: 10,
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 50),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 70,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 8),
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

  const DrawerItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 30, height: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          )
        ],
      ),
    );
  }
}
