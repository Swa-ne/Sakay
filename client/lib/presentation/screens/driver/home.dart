import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/bloc/announcement/announcement_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_event.dart';
import 'package:sakay_app/bloc/announcement/announcement_state.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/bloc/tracker/tracker_state.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/popup_notification.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/common/inbox.dart';
import 'package:sakay_app/presentation/screens/common/announcements.dart';
import 'package:sakay_app/presentation/screens/driver/homepage.dart';
import '../common/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TrackerBloc _trackerBloc;
  late AnnouncementBloc _announcementBloc;
  late ChatBloc _chatBloc;
  final Tracker tracker = Tracker();

  final TokenControllerImpl _tokenController = TokenControllerImpl();

  // Announcements
  final List<AnnouncementsModel> announcements = [];
  String currentAnnouncementCursor = "";
  final ScrollController _scrollAnnouncementController = ScrollController();
  bool isLoadingAnnouncement = false;

  // Messages
  final List<MessageModel> messages = [];
  String currentMessageCursor = "";
  final ScrollController _scrollMessageController = ScrollController();
  bool isLoadingMessage = false;

  late String user_id;
  String? chat_id;
  bool isLoadingUser = true;

  void _onMessageSent(MessageModel message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  // Scroll Listeners
  void _onScrollAnnouncement() {
    if (_scrollAnnouncementController.position.pixels <= 100 &&
        !isLoadingAnnouncement) {
      setState(() {
        isLoadingAnnouncement = true;
      });
      _announcementBloc
          .add(GetAllAnnouncementsEvent(currentAnnouncementCursor));
    }
  }

  void _onScrollMessage() {
    if (_scrollMessageController.position.pixels <= 100 &&
        !isLoadingMessage &&
        chat_id != null) {
      setState(() {
        isLoadingMessage = true;
      });
      _chatBloc.add(GetMessageEvent(chat_id!, currentMessageCursor));
    }
  }

  @override
  void initState() {
    super.initState();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);

    _initializeUserID();
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
    setState(() => isLoadingUser = false);

    _chatBloc.add(ConnectRealtimeEvent());
    _announcementBloc.add(ConnectAnnouncementRealtimeEvent());
    _trackerBloc.add(ConnectEvent());
    _trackerBloc.stream
        .firstWhere((state) => state is ConnectedSocket)
        .then((_) {
      _trackerBloc.add(ConnectDriverEvent());
    });
    _announcementBloc.stream
        .firstWhere((state) => state is ConnectedAnnouncementRealtimeSocket)
        .then((_) {
      _announcementBloc
          .add(GetAllAnnouncementsEvent(currentAnnouncementCursor));
    });

    _chatBloc.stream
        .firstWhere((state) => state is CreateInboxSuccess)
        .then((state) {
      setState(() {
        chat_id = (state as CreateInboxSuccess).chat_id;
      });
      _chatBloc.add(GetMessageEvent(chat_id!, currentMessageCursor));
    });

    _chatBloc.add(CreateInboxEvent());

    _scrollAnnouncementController.addListener(_onScrollAnnouncement);
    _scrollMessageController.addListener(_onScrollMessage);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUser || chat_id == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pages = [
      const DriverHomePage(),
      InboxScreen(
        messages: messages,
        scrollInboxController: _scrollMessageController,
        is_loading_inbox: isLoadingMessage,
        chat_id: chat_id!,
        user_id: user_id,
        onMessageSent: _onMessageSent,
      ),
      AnnouncementsScreen(
        announcements: announcements,
        scrollAnnouncementController: _scrollAnnouncementController,
        isLoadingAnnouncement: isLoadingAnnouncement,
      ),
      const ProfilePage(
        user_type: "DRIVER",
      ),
    ];

    return BlocListener<AnnouncementBloc, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementLoading) {
          setState(() => isLoadingAnnouncement = true);
        } else if (state is GetAllAnnouncementsSuccess) {
          setState(() {
            announcements.addAll(state.announcements);
            currentAnnouncementCursor = state.cursor;
            isLoadingAnnouncement = false;
          });
        } else if (state is OnReceiveAnnouncementSuccess) {
          if (_selectedIndex != 2) {
            showTopNotification(
              context,
            );
          }
          setState(() {
            announcements.insert(0, state.announcement);
            isLoadingAnnouncement = false;
          });
        } else if (state is GetAllAnnouncementsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
          setState(() => isLoadingAnnouncement = false);
        } else if (state is OnReceiveAnnouncementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
          setState(() => isLoadingAnnouncement = false);
        }
      },
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoading) {
            setState(() => isLoadingMessage = true);
          } else if (state is GetMessageSuccess) {
            setState(() {
              messages.addAll(state.messages);
              currentMessageCursor = state.cursor;
              isLoadingMessage = false;
            });
          } else if (state is OnReceiveMessageSuccess) {
            if (_selectedIndex != 1) {
              showTopNotification(
                context,
                icon: Icons.chat_bubble,
                isUserReply: true,
                message: state.message.message,
                imageUrl: state.user.profile,
              );
            }
            if (chat_id == state.message.chat_id) {
              setState(() {
                messages.insert(0, state.message);
                isLoadingMessage = false;
              });
            }
          } else if (state is GetMessageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
            setState(() => isLoadingMessage = false);
          } else if (state is OnReceiveMessageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
            setState(() => isLoadingMessage = false);
          }
        },
        child: Scaffold(
          // made some changes but didn't take effect
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF00A2FF),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle:
                const TextStyle(fontSize: 10, color: Colors.grey),
            unselectedLabelStyle:
                const TextStyle(fontSize: 10, color: Colors.grey),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Maps',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inbox),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.campaign),
                label: 'Announcements',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
