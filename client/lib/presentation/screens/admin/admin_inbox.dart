import 'package:flutter/material.dart';

class AdminInbox extends StatefulWidget {
  const AdminInbox({super.key});

  @override
  State<AdminInbox> createState() => _AdminInboxState();
}

class _AdminInboxState extends State<AdminInbox> {
  final List<Map<String, dynamic>> inboxes = [
    {
      "name": "John Doe",
      "message": "Hey, how's it going?",
      "time": "10:45 AM",
      "avatar": "assets/john.png",
      "unread": true
    },
    {
      "name": "Emma Watson",
      "message": "I'll call you later.",
      "time": "9:30 AM",
      "avatar": "assets/emma.png",
      "unread": false
    },
    {
      "name": "Chris Evans",
      "message": "Let's meet at 5 PM.",
      "time": "Yesterday",
      "avatar": "assets/chris.png",
      "unread": true
    },
    {
      "name": "Sophia Lee",
      "message": "Can you send me the file?",
      "time": "Monday",
      "avatar": "assets/sophia.png",
      "unread": false
    },
    {
      "name": "David Brown",
      "message": "Thanks for the help!",
      "time": "Sunday",
      "avatar": "assets/david.png",
      "unread": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              "Inbox",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

          // Inbox List
          Expanded(
            child: ListView.builder(
              itemCount: inboxes.length,
              itemBuilder: (context, index) {
                final inbox = inboxes[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(inbox["avatar"]!),
                  ),
                  title: Text(
                    inbox["name"]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: inbox["unread"]! ? Colors.blue : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    inbox["message"]!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: inbox["unread"]! ? FontWeight.bold : FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        inbox["time"]!,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      if (inbox["unread"]!)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.circle, color: Colors.blue, size: 10),
                        ),
                    ],
                  ),
                  onTap: () {
                    // Mark as read when tapped
                    setState(() {
                      inboxes[index]["unread"] = false;
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
