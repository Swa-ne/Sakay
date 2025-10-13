import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/core/configs/theme/theme_cubit.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/commuters/Profile%20Settings/About.dart';
import 'package:sakay_app/presentation/screens/commuters/Profile%20Settings/EditAccount.dart';
import 'package:sakay_app/presentation/screens/commuters/Profile%20Settings/LanguagePreference.dart';
import 'package:sakay_app/presentation/screens/commuters/Profile%20Settings/TermsConditions.dart';
import 'package:sakay_app/presentation/screens/commuters/Profile%20Settings/ThemeCustomization.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF718096);

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
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color.fromARGB(255, 249, 249, 249),
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
                    child: Center(
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profile,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                  'assets/profile.jpg',
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
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              _buildSection(
                context,
                title: "Settings",
                icon: Icons.settings,
                children: [
                  _buildGroupedSettingsOption(
                    context,
                    Icons.account_circle,
                    'Account',
                    'Manage your personal account information',
                    isFirst: true,
                  ),
                  _buildDivider(isDark),
                  // _buildGroupedSettingsOption(
                  //   context,
                  //   Icons.language,
                  //   'Language Preference',
                  //   'Select the language that best fits your needs',
                  // ),
                  // _buildDivider(isDark),

                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final isDarkMode = themeMode == ThemeMode.dark;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 16.0),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(isDark ? 0.1 : 0.04),
                              offset: const Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00A2FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.dark_mode,
                                color: Color(0xFF00A2FF),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF2D3748),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Switch between light and dark themes',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white70
                                          : const Color(0xFF718096),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ThemeCubit>()
                                    .toggleTheme(!isDarkMode);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 46,
                                height: 26,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? const Color(0xFF00A2FF)
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: isDarkMode
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  // _buildDivider(isDark),

                  // _buildGroupedSettingsOption(
                  //   context,
                  //   Icons.palette,
                  //   'Theme Customization',
                  //   'Adjust the app\'s appearance to suit your style',
                  //   isLast: true,
                  // ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildSection(
                context,
                title: "Information",
                icon: Icons.info_outline,
                children: [
                  _buildGroupedSettingsOption(
                    context,
                    Icons.description,
                    'Terms and Conditions',
                    'View the terms and conditions of using Sakay',
                    isFirst: true,
                  ),
                  _buildDivider(isDark),
                  _buildGroupedSettingsOption(
                    context,
                    Icons.info,
                    'About',
                    'Explore Sakay\'s features and meet the developers',
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () {
                    _authBloc.add(LogoutEvent());
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.red[700]?.withOpacity(
                              0.2) // Dark mode: darker red with opacity
                          : Colors
                              .red[50], // Light red background in light mode
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.red, // Pure red outline
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: const Offset(0, 4),
                            blurRadius: 12.0,
                          ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: isDark ? Colors.white : Colors.red,
                          size: 22,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF00A2FF), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedSettingsOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBackgroundColor = isDark
        ? const Color(0xFF00A2FF).withOpacity(0.2)
        : const Color(0xFF00A2FF).withOpacity(0.1);
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);
    final subTextColor = isDark ? Colors.white70 : const Color(0xFF718096);

    return InkWell(
      onTap: () {
        if (title == 'Account') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditAccount(
                userType: widget.user_type,
                fullName: fullName,
                profile: profile,
              ),
            ),
          );
        } else if (title == 'Language Preference') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguagePreferencePage(),
            ),
          );
        } else if (title == 'Theme Customization') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ThemeCustomizationPage(),
            ),
          );
        } else if (title == 'Terms and Conditions') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsConditions()),
          );
        } else if (title == 'About') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
              offset: const Offset(0, 2),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF00A2FF),
                size: 20,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: subTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 1,
      color: isDark ? Colors.grey[800] : const Color(0xFFF7FAFC),
    );
  }
}
