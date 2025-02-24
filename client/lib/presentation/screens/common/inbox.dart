import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/common/widgets/chat_bubble.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late ChatBloc _chatBloc;

  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  late String user_id;
  late String chat_id;

  List<MessageModel> messages = [];

  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(CreateInboxEvent());
    _initializeUserID();
    _scrollController.addListener(_onScroll);
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      _chatBloc.add(
        SaveMessageEvent(
          message,
          chat_id,
          "",
        ),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _chatBloc.add(GetMessageEvent(chat_id, currentPage));
    }
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is SaveMessageSuccess) {
          setState(() {
            messages.insert(
              0,
              MessageModel(
                message: messageController.text,
                sender: user_id,
                chat_id: chat_id,
                is_read: false,
                created_at: DateTime.now().toString(),
                updated_at: DateTime.now().toString(),
              ),
            );
            messageController.clear();
          });
        } else if (state is CreateInboxSuccess) {
          setState(() {
            chat_id = state.chat_id;
          });

          _chatBloc.add(GetMessageEvent(chat_id, currentPage));
        } else if (state is GetMessageSuccess) {
          setState(() {
            messages.addAll(state.messages);
            isLoading = false;
          });
        } else if (state is OnReceiveMessageSuccess) {
          if (chat_id == state.message.chat_id) {
            setState(() {
              messages.insert(0, state.message);
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.black), // back button
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
                itemCount: messages.length,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  bool isMe = user_id == messages[index].sender;
                  return chatBubble(messages[index].message, isMe);
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
