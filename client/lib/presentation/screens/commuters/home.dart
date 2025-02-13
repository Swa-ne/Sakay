import 'package:flutter/material.dart';
import 'package:sakay_app/common/widgets/map.dart';
import '../commuters/profile.dart';
import 'notifications.dart';
import 'inbox.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  OverlayEntry? _hintOverlay;
  bool _showInboxHint = true;
  bool _showNotificationsHint = false;
  bool _showProfileHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showInboxHint) {
        _showHint(
          title: "Inbox",
          icon: Icons.inbox,
          message: "The inbox is where you can find your chats, messages, and othet communication means within the application",
          onDismiss: _dismissInboxHint,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      final pages = [
        const HomePage(),
        const InboxScreen(),
        const NotificationsScreen(),
        const ProfilePage(),
      ];

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => pages[index],
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      );
    }
  }

  void _dismissInboxHint() {
    _hintOverlay?.remove();
    setState(() {
      _showInboxHint = false;
      _showNotificationsHint = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_showNotificationsHint) {
        _showHint(
          title: "Notifications",
          icon: Icons.notifications,
          message: "In the notifications tab, it will provide you with everything you need to be aware of such as alerts and warnings to make sure you know what is happening",
          onDismiss: _dismissNotificationsHint,
        );
      }
    });
  }

  void _dismissNotificationsHint() {
    _hintOverlay?.remove();
    setState(() {
      _showNotificationsHint = false;
      _showProfileHint = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_showProfileHint) {
        _showHint(
          title: "Profile",
          icon: Icons.person,
          message: "The profile tab will allow you to customize your preferences, see your priviliges within the application, and provide you with other options for a better, tailored performance",
          onDismiss: _dismissProfileHint,
        );
      }
    });
  }

  void _dismissProfileHint() {
    _hintOverlay?.remove();
    setState(() {
      _showProfileHint = false;
    });
  }

  void _showHint({
  required String title,
  required IconData icon,
  required String message,
  required VoidCallback onDismiss,
}) {
  final overlay = Overlay.of(context);
  final Size screenSize = MediaQuery.of(context).size;

  double targetX = 0;
  double bottomPosition = 80; // Default position

  bool isProfileHint = title == "Profile";

  if (title == "Inbox") {
    targetX = screenSize.width * 0.14 + 23; 
  } else if (title == "Notifications") {
    targetX = screenSize.width * 0.39 + 22;
  } else if (isProfileHint) {
    targetX = screenSize.width * 0.80; // Adjust to right for Profile
  }

  _hintOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        // Dark overlay background
        Positioned.fill(
          child: GestureDetector(
            onTap: () {},
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
        ),

        // Hint Box
        Positioned(
          bottom: bottomPosition - 10, // Adjusted to align above the icon
          left: isProfileHint ? targetX - 200 : targetX - 60, // Move left for Profile to keep it inside screen
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                // Hint box
                Container(
                  padding: const EdgeInsets.all(12),
                  width: 260,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onDismiss,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Got it', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow - Adjusted for Profile Hint
                Align(
                  alignment: isProfileHint ? Alignment.bottomRight : Alignment.center,
                  child: Padding(
                    padding: isProfileHint ? const EdgeInsets.only(left: 200) : EdgeInsets.zero, 
                    child: ClipPath(
                      clipper: ArrowClipper(isProfileHint: isProfileHint),
                      child: Container(
                        width: 20,
                        height: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  overlay.insert(_hintOverlay!);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MyMapWidget()),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(hintText: 'Search for a location...', border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Searching for "$query"...')));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00A2FF),
        unselectedItemColor: const Color(0xFF00A2FF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  final bool isProfileHint;

  ArrowClipper({required this.isProfileHint});

  @override
  Path getClip(Size size) {
    Path path = Path();

    if (isProfileHint) {
      path.moveTo(size.width - 20, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 10, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0); // Top-right
      path.lineTo(size.width / 2, size.height);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
