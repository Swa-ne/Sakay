import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/commuters-pwd/home.dart';
import 'package:sakay_app/presentation/screens/commuters-pwd/inbox.dart';
import 'package:sakay_app/presentation/screens/commuters-pwd/notifications.dart';
import 'inboxpwd.dart'; // Import the InboxScreen
import 'notificationspwd.dart'; // Import the NotificationsScreen
import 'homepwd.dart'; // Import the HomePage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 3; // Set default index to Profile tab

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextScreen;
    if (index == 0) {
      nextScreen = const HomePage();
    } else if (index == 1) {
      nextScreen = const InboxScreen();
    } else if (index == 2) {
      nextScreen = const NotificationsScreen();
    } else {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Remove the back button by not including the leading property
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A2FF),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            // Your profile content here...
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
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
