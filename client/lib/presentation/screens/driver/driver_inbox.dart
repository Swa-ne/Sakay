import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverChatPage extends StatefulWidget {
  const DriverChatPage({super.key});

  @override
  State<DriverChatPage> createState() => _DriverChatPageState();
}

class _DriverChatPageState extends State<DriverChatPage> {
  List<Map<String, dynamic>> messages = [
    // {"text": "Hey, how's it going?", "isMe": false, "time": DateTime.now()},
    {"text": "Check", "isMe": true, "time": DateTime.now()},
    {"text": "Check mate", "isMe": false, "time": DateTime.now()},
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
          icon: const Icon(Icons.arrow_back, color: Colors.black), // back button
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/bus.png"),
            ),
            SizedBox(width: 10),
            Text("Sakay", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Column(
        children: [
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
                    if (!isMe)
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("assets/john.png"),
                      ),
                    const SizedBox(width: 8),

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

                    if (isMe)
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("assets/bus.png"),
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
