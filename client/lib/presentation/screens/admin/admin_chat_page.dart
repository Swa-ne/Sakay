import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  List<Map<String, dynamic>> messages = [
    {"text": "Hey, how's it going?", "isMe": false, "time": DateTime.now()},
    {"text": "I'm good! You?", "isMe": true, "time": DateTime.now()},
    {"text": "All good here too!", "isMe": false, "time": DateTime.now()},
  ];

  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          "text": messageController.text.trim(),
          "isMe": true,
          "time": DateTime.now(),
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/john.png"), // Replace with actual image
            ),
            const SizedBox(width: 10),
            const Text("John Doe", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Column(
        children: [
          // CHAT MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isMe = messages[index]["isMe"];
                String formattedTime =
                    DateFormat.Hm().format(messages[index]["time"]);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    // Profile icon for received messages
                    if (!isMe)
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("assets/john.png"), // User's profile icon
                      ),
                    const SizedBox(width: 8), // Space between icon & chat

                    // Chat bubble
                    Column(
                      crossAxisAlignment:
                          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          constraints: const BoxConstraints(maxWidth: 250),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            messages[index]["text"],
                            style: TextStyle(
                                color: isMe ? Colors.white : Colors.black),
                          ),
                        ),
                        // Time below the chat bubble
                        Align(
                          alignment:
                              isMe ? Alignment.bottomRight : Alignment.bottomLeft,
                          child: Text(
                            formattedTime,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    // Profile icon for sent messages (Admin profile image)
                    if (isMe)
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("assets/bus.png"), // Admin's profile icon
                      ),
                  ],
                );
              },
            ),
          ),

          // MESSAGE INPUT BOX
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
