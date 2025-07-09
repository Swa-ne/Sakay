import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/common/widgets/chat_bubble.dart';
import 'package:sakay_app/data/models/inbox.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

class AdminChatPage extends StatefulWidget {
  final String chat_id;
  final InboxModel inbox;
  final Function(MessageModel) updateInboxList;

  const AdminChatPage({
    super.key,
    required this.chat_id,
    required this.inbox,
    required this.updateInboxList,
  });

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

// TODO: Cache messages
class _AdminChatPageState extends State<AdminChatPage> with Convertion {
  final TextEditingController messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  List<MessageModel> messages = [];

  late String receiver_id;
  late ChatBloc _chatBloc;
  late String user_id;

  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _initializeUserID();
    _scrollController.addListener(_onScroll);
    _chatBloc.add(GetMessageEvent(widget.chat_id, currentPage));
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      _chatBloc.add(
        SaveMessageEvent(
          message,
          widget.chat_id,
          widget.inbox.user_id.id,
        ),
      );
      widget.updateInboxList(MessageModel(
        message: message,
        sender: user_id,
        chat_id: widget.chat_id,
        is_read: false,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _chatBloc.add(GetMessageEvent(widget.chat_id, currentPage));
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
            CircleAvatar(
              backgroundImage: NetworkImage(widget.inbox.user_id.profile),
            ),
            const SizedBox(width: 10),
            Text(
              "${widget.inbox.user_id.first_name} ${widget.inbox.user_id.last_name}",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is SaveMessageSuccess) {
            setState(() {
              messages.insert(
                0,
                MessageModel(
                  message: messageController.text,
                  sender: user_id,
                  chat_id: widget.chat_id,
                  is_read: false,
                  createdAt: DateTime.now().toString(),
                  updatedAt: DateTime.now().toString(),
                ),
              );
              messageController.clear();
            });
          } else if (state is GetMessageSuccess) {
            setState(() {
              messages.addAll(state.messages);
              isLoading = false;
            });
          } else if (state is OnReceiveMessageSuccess) {
            if (widget.chat_id == state.message.chat_id) {
              setState(() {
                messages.insert(0, state.message);
              });
            }
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  bool isMe = user_id == messages[index].sender;
                  String formattedTime =
                      formatDateTime(messages[index].createdAt);

                  bool showTimeSeparator = false;
                  if (index < messages.length - 1) {
                    DateTime currentMessageTime =
                        DateTime.parse(messages[index].createdAt);
                    DateTime previousMessageTime =
                        DateTime.parse(messages[index + 1].createdAt);

                    if (currentMessageTime
                            .difference(previousMessageTime)
                            .inMinutes >
                        10) {
                      showTimeSeparator = true;
                    }
                  } else {
                    showTimeSeparator = true;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTimeSeparator)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              formatDate(messages[index].createdAt),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ),
                        ),
                      Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: chatBubble(
                          messages[index].message,
                          isMe,
                          formattedTime,
                        ),
                      ),
                    ],
                  );
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
