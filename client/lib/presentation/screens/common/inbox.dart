import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/common/widgets/chat_bubble.dart';
import 'package:sakay_app/data/models/message.dart';

// TODO: add refresh callback
class InboxScreen extends StatefulWidget {
  final List<MessageModel> messages;
  final ScrollController scrollInboxController;
  final bool is_loading_inbox;
  final String chat_id;
  final String user_id;
  final void Function(MessageModel) onMessageSent;
  const InboxScreen({
    super.key,
    required this.messages,
    required this.scrollInboxController,
    required this.is_loading_inbox,
    required this.chat_id,
    required this.user_id,
    required this.onMessageSent,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late ChatBloc _chatBloc;

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      _chatBloc.add(
        SaveMessageEvent(
          message,
          widget.chat_id,
          "",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is SaveMessageSuccess) {
          widget.onMessageSent(
            MessageModel(
              message: messageController.text,
              sender: widget.user_id,
              chat_id: widget.chat_id,
              is_read: false,
              created_at: DateTime.now().toString(),
              updated_at: DateTime.now().toString(),
            ),
          );
          setState(() {
            messageController.clear();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                itemCount: widget.messages.length,
                reverse: true,
                controller: widget.scrollInboxController,
                itemBuilder: (context, index) {
                  bool isMe = widget.user_id == widget.messages[index].sender;
                  return chatBubble(widget.messages[index].message, isMe);
                },
              ),
            ),
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
      ),
    );
  }
}
