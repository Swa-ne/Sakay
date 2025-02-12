import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  AadminProfileState createState() => AadminProfileState();
}

class AadminProfileState extends State<AdminProfile> {
  String _selectedMapPreference = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A2FF),
        foregroundColor: Colors.white,
        elevation: 0,
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
                color: const Color(0xFF00A2FF),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A2FF),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 8),
                        blurRadius: 5.0,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage: AssetImage('assets/bus.png'),
                          ),
                          SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sakay Administrative',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'System Administrative',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        left: 73,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Change Profile Picture')),
                            );
                          },
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10.0),

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

            // Settings Options
            _buildSettingsOption(Icons.account_circle, 'Account',
                'Manage and update your personal account information'),
            _buildDivider(),
            _buildSettingsOption(Icons.notifications, 'Notifications',
                'Customize how you stay informed with real-time updates'),
            _buildDivider(),
            _buildSettingsOption(
                Icons.edit, 'Manage Accounts', 'Manage a users account'),
            _buildDivider(),
            _buildSettingsOption(Icons.car_rental_sharp, 'Registered Units',
                'View registered units'),
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

  Widget _buildSettingsOption(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 30.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ],
            ),
          ),
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
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
