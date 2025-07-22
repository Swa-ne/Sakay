import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? openDrawer;
  final String user_type;

  const ProfilePage({super.key, this.openDrawer, required this.user_type});

  @override
  AProfilePageState createState() => AProfilePageState();
}

class AProfilePageState extends State<ProfilePage> {
  late AuthBloc _authBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  String _selectedMapPreference = 'default';
  int? selectedLocation;
  double soundVolume1 = 0.5;
  String fullName = "";
  String profile = "";

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    initializeAsync();
  }

  Future<void> initializeAsync() async {
    String firstName = await _tokenController.getFirstName();
    String lastName = await _tokenController.getLastName();
    String profileUrl = await _tokenController.getProfile();
    setState(() {
      fullName = "$firstName $lastName";
      profile = profileUrl;
    });
  }

  void toggleSelection(int value) {
    setState(() {
      selectedLocation = (selectedLocation == value) ? null : value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.go("/login");
        } else if (state is LogoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF00A2FF),
            elevation: 0,
            flexibleSpace: widget.user_type == "ADMIN"
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {
                            widget.openDrawer!();
                          },
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
                  )
                : const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
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
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/profile.jpg',
                                          fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.user_type,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                  'Manage your personal account information'),
              const SizedBox(height: 10),
              _buildSettingsOption(Icons.edit, 'Language Preference',
                  'Select the language that best fits your needs'),
              const SizedBox(height: 10),
              _buildSettingsOption(
                  Icons.car_rental_sharp,
                  'Theme Customization',
                  'Adjust the app\'s appearance to suit your style'),
              const SizedBox(height: 10),
              _buildSettingsOption(Icons.description, 'Terms and Conditions',
                  'View the terms and conditions of using Sakay'),
              const SizedBox(height: 10),
              _buildSettingsOption(Icons.info, 'About',
                  'Explore Sakay\'s features and meet the developers'),
              const SizedBox(height: 30.0),
              _buildLogoutOption(),
              const SizedBox(height: 10.0)
            ],
          ),
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
                    bool isAnnouncementEnabled = false;
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
                        isAnnouncementEnabled,
                        isSoundEffectEnabled,
                        fontSize,
                        vibrationIntensity,
                        soundVolume1,
                        soundVolume2,
                        (val) => setState(() => isDarkMode = val),
                        (val) => setState(() => isAnnouncementEnabled = val),
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
          } else if (title == 'Terms and Conditions') {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => _TermsAndConditionsDialog(),
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
          _authBloc.add(LogoutEvent());
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
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: profile,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/profile.jpg',
                                          fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.user_type,
                                  style: const TextStyle(
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

  Widget _languageTile(String language, String flagUrl,
      String? selectedLanguage, Function(String) toggleLanguage) {
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

// theme customization
  Widget _themeCustomizationPage(
    BuildContext context,
    bool isDarkMode,
    bool isAnnouncementEnabled,
    bool isSoundEffectEnabled,
    int fontSize,
    int vibrationIntensity,
    double soundVolume1,
    double soundVolume2,
    Function(bool) onDarkModeChanged,
    Function(bool) onAnnouncementChanged,
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
            icon: Icons.campaign,
            text: 'Announcement Alert',
            trailing: Switch(
              value: isAnnouncementEnabled,
              onChanged: onAnnouncementChanged,
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
      {required IconData icon,
      required String text,
      required Widget trailing}) {
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
}

// terms and conditions dialog
class _TermsAndConditionsDialog extends StatefulWidget {
  @override
  State<_TermsAndConditionsDialog> createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<_TermsAndConditionsDialog> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📄 Terms and Conditions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Container with Border and ScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'By agreeing to these Terms and Conditions, you acknowledge and accept the following:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '1. Usage of Sakay',
                        'Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route. The app is intended for UPang students, daily commuters, PWDs, and registered drivers.',
                      ),
                      _buildSection(
                        '2. Account & Access',
                        'Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features based on their account type.',
                      ),
                      _buildSection(
                        '3. Data Collection',
                        'By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication and communication purposes. We do not sell or share your information with third parties.',
                      ),
                      _buildSection(
                        '4. Announcements & Communication',
                        'Admins may post important announcements which are visible to users through the app. These may include service updates, route adjustments, or general notices relevant to the Sakay system.',
                      ),
                      _buildSection(
                        '5. Service Availability',
                        'While we aim to provide real-time, accurate vehicle data, Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect real-time tracking at times.',
                      ),
                      _buildSection(
                        '6. Acceptable Use',
                        'Users must not attempt to disrupt the service, misuse data, or impersonate others. Abuse or suspicious activity may result in account restriction.',
                      ),
                      _buildSection(
                        '7. Changes to Terms',
                        'We may update these Terms and Conditions as the service evolves. Users will be notified of significant changes through the app.',
                      ),
                      _buildSection(
                        '8. Contact & Support',
                        'For questions, feedback, or issues, please reach out through our admin portal or the official Sakay website.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isAgreed,
                  activeColor: const Color(0xFF00A2FF),
                  onChanged: (bool? value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'By agreeing to these terms and conditions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAgreed 
                  ? () => Navigator.of(context).pop(true)
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAgreed 
                    ? const Color(0xFF00A2FF) 
                    : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isAgreed ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
