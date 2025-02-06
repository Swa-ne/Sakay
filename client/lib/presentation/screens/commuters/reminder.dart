import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import geolocator
import 'package:sakay_app/common/widgets/map.dart';
import '../commuter/profile_page.dart';

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

  // Function to check if the distance is too far
  Future<void> _checkDistanceAndNavigate() async {
    // Get current location
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Destination location (replace with the actual destination coordinates)
    const double destinationLatitude =
        14.5620; // Example: Latitude of destination
    const double destinationLongitude =
        121.0137; // Example: Longitude of destination

    // Calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      destinationLatitude,
      destinationLongitude,
    );

    // Check if the distance is too far (e.g., greater than 5000 meters)
    if (distanceInMeters > 5000) {
      // Show a reminder if the destination is too far
      _showDistanceReminder();
    } else {
      // Proceed with normal behavior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Destination is within reach!")),
      );
    }
  }

  // Show a pop-up reminder if the destination is too far
  void _showDistanceReminder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning"),
          content: const Text(
              "The destination is too far away. Would you like to continue?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Continue"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Proceed with destination selection or other actions
              },
            ),
          ],
        );
      },
    );
  }

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
                      onPressed:
                          _checkDistanceAndNavigate, // Check distance when pressed
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

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Calls _onItemTapped when a tab is clicked
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
