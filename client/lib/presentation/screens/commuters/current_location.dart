import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import '../commuter/profile_page.dart';
import 'notifications.dart'; // Import the NotificationsScreen
import 'inbox.dart'; // Import the InboxScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrentLocationPage(),
    );
  }
}

class CurrentLocationPage extends StatefulWidget {
  const CurrentLocationPage({super.key});

  @override
  _CurrentLocationPageState createState() => _CurrentLocationPageState();
}

class _CurrentLocationPageState extends State<CurrentLocationPage> {
  int _selectedIndex = 0; // Keeps track of the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to ProfilePage if index is 3 (Profile tab)
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ProfilePage()), // Open ProfilePage
      );
    }
    // Navigate to NotificationsScreen if index is 2 (Notifications tab)
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationsScreen()), // Open NotificationsScreen
      );
    }
    // Navigate to InboxScreen if index is 1 (Inbox tab)
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InboxScreen()), // Open InboxScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Map from MyMapWidget
          const MyMapWidget(), // Use MyMapWidget here

          // Top Search Bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search available rides",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                ),
              ],
            ),
          ),

          // Bottom Location Card
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "5045 P Burgos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "0.0km | Makati, Metro Manila, 1210, (02) 897 8069",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Search your destination"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with black background
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Calls _onItemTapped when a tab is clicked
        backgroundColor: Colors.black, // Set background to black
        selectedItemColor: Colors.white, // Set selected item color to white
        unselectedItemColor: Colors.grey, // Set unselected item color to grey
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // The Profile tab
          ),
        ],
      ),
    );
  }
}
