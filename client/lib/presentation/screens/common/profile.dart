import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  AProfilePageState createState() => AProfilePageState();
}

class AProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMapPreference = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF00A2FF),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // function
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 15,
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
                    top: 10.0,
                    left: 30.0,
                    right: 30.0,
                    bottom: 30.0), // Reduced top padding
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
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10.0),
            _buildSettingsOption(Icons.account_circle, 'Account',
                'Manage and update your personal account information'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.notifications, 'Saved Locations',
                'Easily access your most frequented destinations'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.edit, 'Language Preference',
                'Select the language that best fits your needs'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.car_rental_sharp, 'Theme Customization',
                'Adjust the app’s appearance to suit your style'),
            const SizedBox(height: 10),
            _buildSettingsOption(Icons.car_rental_sharp, 'About',
                'Discover more about Sakay and its features'),
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
          print('Tapped: $title');

          if (title == 'Account') {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              builder: (context) => _accountPage(context),
            );
          } else if (title == 'Saved Locations') {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: _savedLocationsPage(context),
              ),
            );
          } else if (title == 'Language Preference') {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: _languagePreferencePage(context),
              ),
            );
          } else if (title == 'Theme Customization') {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: _themeCustomizationPage(context),
              ),
            );
          } else if (title == 'About') {
            showDialog(
              context: context,
              barrierColor:
                  Colors.transparent, // Optional: To make it feel native
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                insetPadding: EdgeInsets.zero,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: _aboutPage(context),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title tapped')),
            );
          }
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
          child: const Row(
            children: [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 10.0),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _accountPage(BuildContext context) {
  bool _isPasswordVisible = false;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Edit Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField('Name', Icons.edit, false),
              const SizedBox(height: 10),
              _buildInputField('Email', Icons.edit, false),
              const SizedBox(height: 10),
              _buildPasswordField(setState, _isPasswordVisible),
              const SizedBox(height: 10),
              _buildInputField('Phone Number', Icons.edit, false),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FF),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Account updated successfully')),
                  );
                },
                child: const Center(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInputField(String label, IconData editIcon, bool isPassword) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            right: 10,
            child: Icon(editIcon, color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

Widget _buildPasswordField(
    void Function(void Function()) setState, bool isPasswordVisible) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Password',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const Positioned(
            right: 10,
            child: Icon(Icons.edit, color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

void showEditAccountPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => _accountPage(context),
  );
}

Widget _savedLocationsPage(BuildContext context) {
  return Container(
    height: 550,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.black, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Saved Locations',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                        constraints: const BoxConstraints(maxHeight: 32),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        hintText: 'Search saved locations',
                        hintStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text(
                  'CSI Lucao',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: const Text(
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Radio(value: 1, groupValue: 1, onChanged: (_) {}),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text(
                  'King Fisher',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: const Text(
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Radio(value: 2, groupValue: 1, onChanged: (_) {}),
              ),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: const Text(
                  'Lingayen',
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: const Text(
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Radio(value: 3, groupValue: 1, onChanged: (_) {}),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue, size: 20),
                onPressed: () {
                  // add function
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  // delete function
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _languagePreferencePage(BuildContext context) {
  return Container(
    height: 550,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.language, color: Colors.black, size: 18),
            SizedBox(width: 10),
            Text(
              'Language Preference',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 8),
        Column(
          children: [
            _languageTile('Tagalog', 'https://flagcdn.com/w40/ph.png'),
            _languageTile('English', 'https://flagcdn.com/w40/us.png'),
            _languageTile('Mandarin', 'https://flagcdn.com/w40/cn.png'),
          ],
        ),
        const Spacer(),
        Center(
          child: SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _languageTile(String language, String flagUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        leading: Image.network(
          flagUrl,
          width: 16,
          height: 10,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.flag, size: 16, color: Colors.grey),
        ),
        title: Text(
          language,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.radio_button_unchecked, color: Colors.grey),
      ),
    ),
  );
}

Widget _themeCustomizationPage(BuildContext context) {
  return Container(
    height: 550,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_pin, color: Colors.black, size: 18),
            SizedBox(width: 8),
            Text(
              'Customization',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 8),
        _customizationOption(
          icon: Icons.dark_mode,
          text: 'Dark Mode',
          trailing: Switch(value: false, onChanged: (value) {}),
        ),
        _customizationOption(
          icon: Icons.notifications,
          text: 'Notification Alert',
          trailing: Switch(value: false, onChanged: (value) {}),
        ),
        _customizationOption(
          icon: Icons.notifications,
          text: 'Sound Effect',
          trailing: Switch(value: false, onChanged: (value) {}),
        ),
        _customizationOption(
          icon: Icons.text_fields,
          text: 'Font Size',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {},
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Sound and Vibration',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 8),
        _customizationOption(
          icon: Icons.vibration,
          text: 'Vibration Intensity',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.remove, size: 18), onPressed: () {}),
              const Text('3', style: TextStyle(fontSize: 14)),
              IconButton(
                  icon: const Icon(Icons.add, size: 18), onPressed: () {}),
            ],
          ),
        ),
        _soundSlider(),
        _soundSlider(),
      ],
    ),
  );
}

Widget _customizationOption(
    {required IconData icon, required String text, required Widget trailing}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87, size: 18),
              const SizedBox(width: 10),
              Text(text, style: const TextStyle(fontSize: 13)),
            ],
          ),
          trailing,
        ],
      ),
    ),
  );
}

Widget _soundSlider() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Row(
      children: [
        const Icon(Icons.volume_up, size: 18),
        const SizedBox(width: 3),
        Expanded(
          child: Slider(
            value: 0.5,
            onChanged: (value) {},
            activeColor: const Color(0xFF00A2FF),
            inactiveColor: Colors.grey.shade300,
          ),
        ),
      ],
    ),
  );
}

Widget _aboutPage(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.white,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.black, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'About',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.grey),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sakay is an innovative real-time bus tracking system designed to enhance the commuting experience along the Lingayen-Dagupan route. Developed to address common transportation challenges such as delays, overcrowding, and the lack of real-time information, Sakay utilizes GPS technology to deliver accurate updates on vehicle locations, estimated arrival times, and proximity alerts.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
                Text(
                  'Our mission is to transform public transportation by prioritizing reliability, efficiency, and accessibility for commuters, drivers, and operators. Through advanced features like route optimization and real-time vehicle tracking, Sakay reduces delays, improves operational efficiency, and elevates the overall travel experience.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
                Text(
                  'This project is a product of the collaborative efforts of a dedicated team from PHINMA – University of Pangasinan. Motivated by the growing need for efficient and reliable public transportation, the Sakay team has developed a solution that prioritizes data accuracy, passenger safety, and user-friendly functionality, ensuring a seamless experience for all users.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
                Text(
                  'By promoting sustainable urban mobility, Sakay not only addresses the immediate needs of commuters but also contributes to reducing traffic congestion and supporting the shift toward more efficient public transportation systems.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(Icons.handshake, size: 20, color: Colors.black),
                SizedBox(width: 6),
                Text(
                  'Meet the Team',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _teamMemberPlaceholder('Lance Manaois', 'Project Manager & Lead Developer'),
              _teamMemberPlaceholder('Stephen Bautista', 'Backend Developer & Team Manager'),
              _teamMemberPlaceholder('Jaspher Tania', 'UI/UX Designer & Frontend Developer'),
              _teamMemberPlaceholder('Mark Joshua Sarmient', 'Frontend Developer'),
              _teamMemberPlaceholder('Christian Majin', 'Frontend Developer'),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _teamMemberPlaceholder(String name, String position) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              position,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    ),
  );
}