import 'package:flutter/material.dart';
import 'inbox.dart'; // Import the InboxScreen
import 'notifications.dart'; // Import the NotificationsScreen

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3; // Set to 3 for Profile tab by default

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
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A2FF),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile content...
            // Your profile content remains the same
            SizedBox(height: 20.0),

            // Settings Section
            // Settings and logout content...
          ],
        ),
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
