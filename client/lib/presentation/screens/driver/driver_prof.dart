import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';
import 'package:sakay_app/presentation/screens/driver/driver_location.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  ADriverProfileState createState() => ADriverProfileState();
}

class ADriverProfileState extends State<DriverProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMapPreference = 'default';
  String _selectedItem = "Profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF00A2FF),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white), // back button
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const DriverLocation(),
                    )
                  )
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                padding: const EdgeInsets.only(
                    top: 10.0, left: 30.0, right: 30.0, bottom: 30.0),
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
                            backgroundImage: AssetImage('assets/swane.png'),
                          ),
                          SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stephen Bautista',
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
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
              child: Text(
                'Select a preferred view of the map',
                style: TextStyle(fontSize: 10.0, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMapOption('Default', 'assets/default_map.png'),
                  _buildMapOption('Terrain', 'assets/terrain_map.png'),
                  _buildMapOption('Satellite', 'assets/satellite_map.png'),
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
            _buildSettingsOption(Icons.account_circle, 'Account',
                'Manage and update your personal account information'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.location_city, 'Saved Locatons',
                'Easily access your most frequented destinations'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.edit, 'Language Preferences',
                'Select the language that best fits your needs'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.car_rental_sharp, 'Theme Customization',
                'Adjust the app’s appearance to suit your styleunits'),
            _buildSettingsOption(Icons.info_outline, 'About',
                'Discover more about Sakay and its featuresunits'),
            const SizedBox(height: 10),
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
                    ? Colors.blue
                    : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5.0),
          Text(
            preference,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: _selectedMapPreference == preference
                  ? Colors.blue
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logging out...')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 20.0),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
