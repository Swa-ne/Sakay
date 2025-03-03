import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_reports.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

class AdminInbox extends StatefulWidget {
  const AdminInbox({super.key});

  @override
  State<AdminInbox> createState() => _AdminInboxState();
}

class _AdminInboxState extends State<AdminInbox> {
  String _selectedItem = "Inbox";

  final List<Map<String, dynamic>> inboxes = [
    {
      "name": "John Walker",
      "message": "Hey, how's it going?",
      "time": "10:45 AM",
      "avatar": "https://randomuser.me/api/portraits/men/1.jpg",
      "unread": true
    },
    {
      "name": "Tony Stark",
      "message": "I'll call you later.",
      "time": "9:30 AM",
      "avatar": "https://randomuser.me/api/portraits/women/2.jpg",
      "unread": false
    },
    {
      "name": "Chris Evans",
      "message": "Let's meet at 5 PM.",
      "time": "Yesterday",
      "avatar": "https://randomuser.me/api/portraits/men/3.jpg",
      "unread": true
    },
    {
      "name": "Scarlett Johansson",
      "message": "Can you send me the file?",
      "time": "Monday",
      "avatar": "https://randomuser.me/api/portraits/women/4.jpg",
      "unread": false
    },
    {
      "name": "Mark Ruffalo",
      "message": "Thanks for the help!",
      "time": "Sunday",
      "avatar": "https://randomuser.me/api/portraits/men/5.jpg",
      "unread": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF00A3FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/bus.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.white, thickness: 1),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Map";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminMap()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.map,
                        text: "Map",
                        isSelected: _selectedItem == "Map",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Surveillance";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminSurveillance()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.camera,
                        text: "Surveillance",
                        isSelected: _selectedItem == "Surveillance",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Report";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminReports()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.bar_chart,
                        text: "Report",
                        isSelected: _selectedItem == "Report",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Notifications";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminNotification()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.notifications,
                        text: "Notifications",
                        isSelected: _selectedItem == "Notifications",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Inbox";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminInbox()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.inbox,
                        text: "Inbox",
                        isSelected: _selectedItem == "Inbox",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Profile";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminProfile()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.person,
                        text: "Profile",
                        isSelected: _selectedItem == "Profile",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xFF00A3FF),
          elevation: 0,
          title: const Text(
            'Inbox',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
        ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inboxes.length,
              itemBuilder: (context, index) {
                final inbox = inboxes[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: inbox["avatar"]!,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 28,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person),
                    ),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.error),
                    ),
                  ),
                  title: Text(
                    inbox["name"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    inbox["message"]!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: inbox["unread"]!
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: inbox["unread"]!
                          ? Colors.black
                          : Colors
                              .grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        inbox["time"]!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      if (inbox[
                          "unread"]!)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 8,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      inboxes[index]["unread"] =
                          false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: isSelected ? 40 : 50,
          width: isSelected ? 350 : 250,
          padding: isSelected
              ? const EdgeInsets.only(left: 10)
              : const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 30),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
