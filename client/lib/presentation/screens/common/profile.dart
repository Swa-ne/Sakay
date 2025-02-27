import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  AProfilePageState createState() => AProfilePageState();
}

class AProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedMapPreference = 'default';
  int? selectedLocation;
  double soundVolume1 = 0.5;

  void toggleSelection(int value) {
    setState(() {
      selectedLocation = (selectedLocation == value) ? null : value;
    });
  }

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
          flexibleSpace: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
            _buildSettingsOption(Icons.info, 'About',
                'Explore Sakay’s features and meet the developers'),
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
              builder: (context) {
                int? selectedLocation;

                return StatefulBuilder(
                  builder: (context, setState) {
                    void toggleSelection(int value) {
                      setState(() {
                        selectedLocation =
                            (selectedLocation == value) ? null : value;
                      });
                    }

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: savedLocationsPage(
                          context, selectedLocation, toggleSelection),
                    );
                  },
                );
              },
            );
          } else if (title == 'Language Preference') {
            showDialog(
              context: context,
              builder: (context) {
                String? selectedLanguage;

                return StatefulBuilder(
                  builder: (context, setState) {
                    void toggleLanguage(String language) {
                      setState(() {
                        selectedLanguage =
                            (selectedLanguage == language) ? null : language;
                      });
                    }

                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _languagePreferencePage(
                          context, selectedLanguage, toggleLanguage),
                    );
                  },
                );
              },
            );
          } else if (title == 'Theme Customization') {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    bool isDarkMode = false;
                    bool isNotificationEnabled = false;
                    bool isSoundEffectEnabled = false;
                    int fontSize = 14;
                    int vibrationIntensity = 3;
                    double soundVolume1 = 0.5;
                    double soundVolume2 = 0.5;

                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: _themeCustomizationPage(
                        context,
                        isDarkMode,
                        isNotificationEnabled,
                        isSoundEffectEnabled,
                        fontSize,
                        vibrationIntensity,
                        soundVolume1,
                        soundVolume2,
                        (val) => setState(() => isDarkMode = val),
                        (val) => setState(() => isNotificationEnabled = val),
                        (val) => setState(() => isSoundEffectEnabled = val),
                        (val) => setState(() => fontSize = val),
                        (val) => setState(() => vibrationIntensity = val),
                        (val) => setState(() => soundVolume1 = val),
                        (val) => setState(() => soundVolume2 = val),
                      ),
                    );
                  },
                );
              },
            );
          } else if (title == 'About') {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
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

// account
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
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Edit Account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
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
              const SizedBox(height: 20),
              _buildInputField('Name', Icons.person, false),
              const SizedBox(height: 10),
              _buildInputField('Email', Icons.email, false),
              const SizedBox(height: 10),
              _buildPasswordField(setState, _isPasswordVisible),
              const SizedBox(height: 10),
              _buildInputField('Phone Number', Icons.phone, false),
              const SizedBox(height: 15),
              const Divider(color: Colors.grey, thickness: 0.5),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: const Color(0xFF00A2FF),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Account updated successfully')),
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInputField(String label, IconData icon, bool isPassword) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: Icon(icon, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              SnackBar(content: Text('Edit $label'));
            },
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
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      key: ValueKey(isPasswordVisible),
                      color: Colors.grey,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              const SnackBar(content: Text('Edit Password'));
            },
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
    backgroundColor: Colors.transparent,
    builder: (context) => _accountPage(context),
  );
}

// ----------------------------------------------------------------

// saved location page
Widget savedLocationsPage(BuildContext context, int? selectedLocation,
    void Function(int) toggleSelection) {
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
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
              _buildLocationTile(
                  1,
                  'CSI Lucao',
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  selectedLocation,
                  toggleSelection),
              _buildLocationTile(
                  2,
                  'King Fisher',
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  selectedLocation,
                  toggleSelection),
              _buildLocationTile(
                  3,
                  'Lingayen',
                  '28CF+CH5, Dagupan - Binmaley Rd.',
                  selectedLocation,
                  toggleSelection),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, bottom: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue, size: 20),
                  onPressed: () {
                    // Add function
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    // Delete function
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildLocationTile(int value, String title, String subtitle,
    int? selectedLocation, void Function(int) toggleSelection) {
  return ListTile(
    leading: const Icon(Icons.location_on, color: Colors.blue),
    title: Text(title, style: const TextStyle(fontSize: 12)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 10)),
    trailing: Radio<int>(
      value: value,
      groupValue: selectedLocation,
      onChanged: (val) => toggleSelection(val!),
    ),
  );
}

// ----------------------------------------------------------------

// language preference
Widget _languagePreferencePage(BuildContext context, String? selectedLanguage,
    Function(String) toggleLanguage) {
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
            _languageTile('Tagalog', 'https://flagcdn.com/w40/ph.png',
                selectedLanguage, toggleLanguage),
            _languageTile('English', 'https://flagcdn.com/w40/us.png',
                selectedLanguage, toggleLanguage),
            _languageTile('Mandarin', 'https://flagcdn.com/w40/cn.png',
                selectedLanguage, toggleLanguage),
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
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 5),
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

Widget _languageTile(String language, String flagUrl, String? selectedLanguage,
    Function(String) toggleLanguage) {
  return ListTile(
    leading: Image.network(flagUrl, width: 30, height: 20),
    title: Text(language, style: const TextStyle(fontSize: 12)),
    trailing: Radio<String>(
      value: language,
      groupValue: selectedLanguage,
      onChanged: (value) => toggleLanguage(value!),
    ),
  );
}

// ----------------------------------------------------------------

// theme customization
Widget _themeCustomizationPage(
  BuildContext context,
  bool isDarkMode,
  bool isNotificationEnabled,
  bool isSoundEffectEnabled,
  int fontSize,
  int vibrationIntensity,
  double soundVolume1,
  double soundVolume2,
  Function(bool) onDarkModeChanged,
  Function(bool) onNotificationChanged,
  Function(bool) onSoundEffectChanged,
  Function(int) onFontSizeChanged,
  Function(int) onVibrationChanged,
  Function(double) onSoundVolume1Changed,
  Function(double) onSoundVolume2Changed,
) {
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
          trailing: Switch(
            value: isDarkMode,
            onChanged: onDarkModeChanged,
          ),
        ),
        _customizationOption(
          icon: Icons.notifications,
          text: 'Notification Alert',
          trailing: Switch(
            value: isNotificationEnabled,
            onChanged: onNotificationChanged,
          ),
        ),
        _customizationOption(
          icon: Icons.volume_up,
          text: 'Sound Effect',
          trailing: Switch(
            value: isSoundEffectEnabled,
            onChanged: onSoundEffectChanged,
          ),
        ),
        _customizationOption(
          icon: Icons.text_fields,
          text: 'Font Size',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  if (fontSize > 10) onFontSizeChanged(fontSize - 1);
                },
              ),
              Text(fontSize.toString(), style: const TextStyle(fontSize: 14)),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  if (fontSize < 20) onFontSizeChanged(fontSize + 1);
                },
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
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  if (vibrationIntensity > 1) {
                    onVibrationChanged(vibrationIntensity - 1);
                  }
                },
              ),
              Text(vibrationIntensity.toString(),
                  style: const TextStyle(fontSize: 14)),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  if (vibrationIntensity < 5) {
                    onVibrationChanged(vibrationIntensity + 1);
                  }
                },
              ),
            ],
          ),
        ),
        _soundSlider(value: soundVolume1, onChanged: onSoundVolume1Changed),
        _soundSlider(value: soundVolume2, onChanged: onSoundVolume2Changed),
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

Widget _soundSlider(
    {required double value, required ValueChanged<double> onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Row(
      children: [
        const Icon(Icons.volume_up, size: 18),
        const SizedBox(width: 3),
        Expanded(
          child: Slider(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF00A2FF),
            inactiveColor: Colors.grey.shade300,
          ),
        ),
      ],
    ),
  );
}

//----------------------------------------------------------------

// about page
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
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 18),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'About',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              _teamMemberPlaceholder(
                'Lance Manaois',
                'Project Manager & Lead Developer',
              ),
              _teamMemberPlaceholder(
                'Stephen Bautista',
                'Full-stack Developer & Team Manager',
              ),
              _teamMemberPlaceholder(
                'Jaspher Tania',
                'UI/UX Designer & Frontend Developer',
              ),
              _teamMemberPlaceholder(
                'Mark Joshua Sarmiento',
                'Frontend Developer',
              ),
              _teamMemberPlaceholder(
                'Christian Majin',
                'Frontend Developer',
              ),
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
