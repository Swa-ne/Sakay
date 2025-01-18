import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _selectedMapPreference = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF3A6C8D),
        automaticallyImplyLeading: true,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30.0),
                color: const Color(0xFF3A6C8D), 
                child: Container(
                  padding: const EdgeInsets.all(10.0), 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(38, 0, 0, 0), 
                    borderRadius: BorderRadius.circular(10.0), 
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage('assets/swane.png'),
                      ),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Swane Bautista', 
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Commuter',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Map Preference',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                'Select a preferred view of the map',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMapOption('default', 'assets/default_map.png'),
                  _buildMapOption('terrain', 'assets/terrain_map.png'),
                  _buildMapOption('satellite', 'assets/satellite_map.png'),
                ],
              ),
            ),

            const SizedBox(height: 30.0),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),

            _buildSettingsOption(Icons.account_circle, 'Account'),
            _buildDivider(),
            _buildSettingsOption(Icons.notifications, 'Notifications'),
            _buildDivider(),
            _buildSettingsOption(Icons.location_on, 'Saved Locations'),
            _buildDivider(),
            _buildSettingsOption(Icons.language, 'Language Preference'),
            _buildDivider(),
            _buildSettingsOption(Icons.format_paint, 'Theme Customization'),
            _buildDivider(),
            _buildSettingsOption(Icons.info, 'About'),
            _buildDivider(),

            const SizedBox(height: 20.0),  

            _buildLogoutOption(),

            const SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }

  Widget _buildMapOption(String preference, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMapPreference = preference;
        });
      },
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedMapPreference == preference
                    ? const Color(0xFF3A6C8D)
                    : Colors.grey,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            preference[0].toUpperCase() + preference.substring(1),
            style: TextStyle(
              color: _selectedMapPreference == preference
                  ? const Color(0xFF3A6C8D)
                  : Colors.grey,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 20.0),
          Text(
            title,
            style: const TextStyle(fontSize: 14.0),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildLogoutOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: GestureDetector(
        onTap: () {
          // Handle logout logic
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out successfully')),
          );
        },
        child: const Row(
          children: [
            Icon(Icons.logout, color: Colors.black),
            SizedBox(width: 20.0),
            Text(
              'Logout',
              style: TextStyle(fontSize: 16.0),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(color: Colors.grey),
    );
  }
}
