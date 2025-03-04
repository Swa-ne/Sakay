import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void showTopNotification(BuildContext context, IconData icon, {bool isUserReply = false}) async {
  String? imageUrl;
  String name;
  String message;

  if (isUserReply) {
    final response = await http.get(Uri.parse('https://randomuser.me/api/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = data['results'][0];
      imageUrl = user['picture']['thumbnail'];
      name = '${user['name']['first']} ${user['name']['last']}';
      message = "replied to your chat.";
    } else {
      imageUrl = 'https://randomuser.me/api/portraits/men/1.jpg';
      name = "Barton Agustillo";
      message = "replied to your chat.";
    }
  } else {
    imageUrl = null;
    name = "Sakay";
    message = "New Announcement from Sakay";
  }

  OverlayState overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 20,
      left: MediaQuery.of(context).size.width * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      child: SlideDownNotification(
        name: name,
        message: message,
        icon: icon,
        overlayEntry: overlayEntry,
        isUserReply: isUserReply,
        imageUrl: imageUrl,
      ),
    ),
  );

  overlayState.insert(overlayEntry);
}

class SlideDownNotification extends StatefulWidget {
  final String name;
  final String message;
  final IconData icon;
  final OverlayEntry overlayEntry;
  final bool isUserReply;
  final String? imageUrl;

  const SlideDownNotification({
    required this.name,
    required this.message,
    required this.icon,
    required this.overlayEntry,
    required this.isUserReply,
    this.imageUrl,
  });

  @override
  _SlideDownNotificationState createState() => _SlideDownNotificationState();
}

class _SlideDownNotificationState extends State<SlideDownNotification> {
  double _topPosition = -100;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _topPosition = 30;
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _topPosition = -30;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.overlayEntry.remove();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: _topPosition,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 2,
                  right: 2,
                  child: Row(
                    children: [
                      Icon(widget.icon, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text(
                        "now",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: widget.isUserReply
                          ? Image.network(
                              widget.imageUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/bus.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 40,
                      child: VerticalDivider(
                        thickness: 1,
                        color: Colors.grey[300],
                        indent: 5,
                        endIndent: 5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.message,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showTopNotification(
                  context,
                  Icons.notifications,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: const Color(0xFF00A2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.black,
                elevation: 8,
              ),
              child: const Text(
                "Show Announcement",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showTopNotification(
                  context,
                  Icons.chat_bubble,
                  isUserReply: true,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.black,
                elevation: 8,
              ),
              child: const Text(
                "Show Chat Reply",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}