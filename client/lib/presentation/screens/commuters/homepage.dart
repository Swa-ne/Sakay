import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Tracker {
  final TextEditingController _searchController = TextEditingController();
  late TrackerBloc _trackerBloc;
  int _selectedIndex = 0;
  OverlayEntry? _hintOverlay;
  bool _showInboxHint = true;
  bool _showNotificationsHint = false;
  bool _showProfileHint = false;

  @override
  void initState() {
    super.initState();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showInboxHint) {
        _showHint(
          title: "Inbox",
          icon: Icons.inbox,
          message:
              "The inbox is where you can find your chats, messages, and othet communication means within the application",
          onDismiss: _dismissInboxHint,
        );
      }
    });
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
          message:
              "In the notifications tab, it will provide you with everything you need to be aware of such as alerts and warnings to make sure you know what is happening",
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
          message:
              "The profile tab will allow you to customize your preferences, see your priviliges within the application, and provide you with other options for a better, tailored performance",
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
            left: isProfileHint
                ? targetX - 200
                : targetX -
                    60, // Move left for Profile to keep it inside screen
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
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onDismiss,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text('Got it',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow - Adjusted for Profile Hint
                  Align(
                    alignment: isProfileHint
                        ? Alignment.bottomRight
                        : Alignment.center,
                    child: Padding(
                      padding: isProfileHint
                          ? const EdgeInsets.only(left: 200)
                          : EdgeInsets.zero,
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
          const Positioned.fill(
            child: MyMapWidget(),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for a location...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Searching for "$query"...')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.location_on,
                          color: Colors.black, size: 20),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Phinma University of Pangasinan',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        '28WV+R2R, Arellano St, Downtown District',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    // replace na lungs
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Location sent"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00A1F8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navBarItem(Icons.map, "Map"),
                  _navBarItem(Icons.inbox, "Inbox"),
                  _navBarItem(Icons.notifications, "Notifications"),
                  _navBarItem(Icons.person, "Profile"),
                  // nav sa baba
                ],
              ),
            ),
          )
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

Widget _navBarItem(IconData icon, String label) {
  return GestureDetector(
      child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: const Color(0xFF00A1F8)),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(
            color: Color(0xFF00A1F8),
            fontSize: 10,
            fontWeight: FontWeight.w600),
      )
    ],
  ));
}
