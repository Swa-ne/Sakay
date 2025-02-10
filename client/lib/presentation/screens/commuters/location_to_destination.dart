import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import 'notifications.dart'; // Import the NotificationsScreen
import 'inbox.dart'; // Import the InboxScreen
import '../commuters/profile.dart';

class LocationToDestinationPage extends StatefulWidget {
  const LocationToDestinationPage({super.key});

  @override
  _LocationToDestinationPageState createState() =>
      _LocationToDestinationPageState();
}

class _LocationToDestinationPageState extends State<LocationToDestinationPage> {
  int _selectedIndex = 0; // Keeps track of the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the respective pages when tapped
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InboxScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   
  onPressed: () {
    Navigator.pop(context); // Closes the dialog when button is clicked
  },
  icon: const Icon(Icons.arrow_back),

IconButton(
  onPressed: () {
    Navigator.pop(context); // Closes the dialog when button is clicked
  },
  icon: const Icon(Icons.person),
),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
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
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
