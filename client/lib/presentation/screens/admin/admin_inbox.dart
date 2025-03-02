import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/common/mixins/convertion.dart';
import 'package:sakay_app/data/models/inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_chat_page.dart';

class AdminInbox extends StatefulWidget {
  final VoidCallback openDrawer;

  const AdminInbox({super.key, required this.openDrawer});

  @override
  State<AdminInbox> createState() => _AdminInboxState();
}

class _AdminInboxState extends State<AdminInbox> with Convertion {
  final List<InboxModel> inboxes = [];
  late ChatBloc _chatBloc;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(GetInboxesEvent(currentPage));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100 && !isLoading) {
      setState(() {
        isLoading = true;
        currentPage++;
      });
      _chatBloc.add(GetInboxesEvent(currentPage));
    }
  }

  Widget _buildInboxList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search", // TODO: add functionality
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
            controller: _scrollController,
            itemCount: inboxes.length,
            itemBuilder: (context, index) {
              final inbox = inboxes[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(inbox.user_id.profile),
                ),
                title: Text(
                  "${inbox.user_id.first_name} ${inbox.user_id.last_name}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        inbox.last_message.is_read ? Colors.blue : Colors.black,
                  ),
                ),
                subtitle: Text(
                  inbox.last_message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: inbox.last_message.is_read
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDateTime(
                        inbox.last_message.created_at,
                      ),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    if (inbox.last_message.is_read)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.circle, color: Colors.blue, size: 10),
                      ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminChatPage(
                          chat_id: inbox.id,
                          inbox: inbox,
                        ),
                      ),
                    );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

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
              icon: const Icon(Icons.menu, color: Colors.black, size: 25),
              onPressed: widget.openDrawer,
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
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetInboxesSuccess) {
            inboxes.clear();
            inboxes.addAll(state.inboxes);
          } else if (state is OnReceiveMessageSuccess) {
            final index = inboxes
                .indexWhere((inbox) => inbox.id == state.message.chat_id);
            if (index != -1) {
              final updatedInbox =
                  inboxes.removeAt(index).copyWith(last_message: state.message);
              inboxes.insert(0, updatedInbox);
            } else {
              inboxes.insert(
                0,
                InboxModel(
                  id: state.message.chat_id,
                  user_id: state.user,
                  last_message: state.message,
                  is_active: true,
                ),
              );
            }
          } else if (state is GetInboxesError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return inboxes.isEmpty
              ? const Center(child: Text("No messages available"))
              : _buildInboxList();
        },
      ),
    );
  }
}
