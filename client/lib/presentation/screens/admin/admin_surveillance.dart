import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart'; // Import the Map widget

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
      routes: {
        '/map': (context) => const AdminMap(), // Navigate to the Map screen
      },
    );
  }
}

class AdminSurveillance extends StatefulWidget {
  const AdminSurveillance({super.key});

  @override
  _AdminSurveillanceState createState() => _AdminSurveillanceState();
}

class _AdminSurveillanceState extends State<AdminSurveillance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                    const DrawerItem(
                        icon: Icons.map, text: "AdminSurveillance"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context,
                            '/map'); // Navigate and replace the current screen
                      },
                      child: const DrawerItem(
                          icon: Icons.location_on, text: "Map"),
                    ),
                    const DrawerItem(icon: Icons.bar_chart, text: "Report"),
                    const DrawerItem(
                        icon: Icons.notifications, text: "Notification"),
                    const DrawerItem(icon: Icons.inbox, text: "Inbox"),
                    const DrawerItem(icon: Icons.settings, text: "Settings"),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: DrawerItem(icon: Icons.logout, text: "Log out"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0),
            child: Row(children: [
              Text("Units",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ]),
          ),
          Expanded(
            child: ListView(
              children: const [
                UnitCard(
                  unitName: "UNIT-17A",
                  address:
                      "Arellano St, Downtown District, Dagupan, 2400 Pangasinan",
                  distance: "2 km",
                  duration: "2h 46min",
                ),
                UnitCard(
                  unitName: "UNIT-07U",
                  address:
                      "Arellano St, Downtown District, Dagupan, 2400 Pangasinan",
                  distance: "2 km",
                  duration: "2h 46min",
                ),
                UnitCard(
                  unitName: "UNIT-84C",
                  address:
                      "Arellano St, Downtown District, Dagupan, 2400 Pangasinan",
                  distance: "2 km",
                  duration: "2h 46min",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UnitCard extends StatelessWidget {
  final String unitName;
  final String address;
  final String distance;
  final String duration;

  const UnitCard({
    super.key,
    required this.unitName,
    required this.address,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/bus.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unitName,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      address,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.local_parking,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 3.0),
                        child: Text(
                          distance,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.lightBlue,
                          size: 15.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          duration,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
          ),
        ],
      ),
    );
  }
}
