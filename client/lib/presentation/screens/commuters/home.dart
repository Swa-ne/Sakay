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
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/popup_notification.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/models/announcement.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/common/inbox.dart';
import 'package:sakay_app/presentation/screens/common/announcements.dart';
import 'package:sakay_app/presentation/screens/commuters/homepage.dart';
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
  int currentAnnouncementPage = 1;
  final ScrollController _scrollAnnouncementController = ScrollController();
  bool isLoadingAnnouncement = false;

  // Messages
  final List<MessageModel> messages = [];
  int currentMessagePage = 1;
  final ScrollController _scrollMessageController = ScrollController();
  bool isLoadingMessage = false;

  late String user_id;
  String? chat_id;
  bool isLoadingUser = true;

  // Scroll Listeners
  void _onScrollAnnouncement() {
    if (_scrollAnnouncementController.position.pixels <= 100 &&
        !isLoadingAnnouncement) {
      setState(() {
        isLoadingAnnouncement = true;
        currentAnnouncementPage++;
      });
      _announcementBloc.add(GetAllAnnouncementsEvent(currentAnnouncementPage));
    }
  }

  void _onScrollMessage() {
    if (_scrollMessageController.position.pixels <= 100 &&
        !isLoadingMessage &&
        chat_id != null) {
      setState(() {
        isLoadingMessage = true;
        currentMessagePage++;
      });
      _chatBloc.add(GetMessageEvent(chat_id!, currentMessagePage));
    }
  }

  void _onMessageSent(MessageModel message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);

    _initializeUserID();
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
    setState(() => isLoadingUser = false);

    _chatBloc.add(ConnectRealtimeEvent());
    _announcementBloc.add(ConnectAnnouncementRealtimeEvent());
    _trackerBloc.add(ConnectEvent());

    _announcementBloc.stream
        .firstWhere((state) => state is ConnectedAnnouncementRealtimeSocket)
        .then((_) {
      _announcementBloc.add(GetAllAnnouncementsEvent(currentAnnouncementPage));
    });

    _chatBloc.stream
        .firstWhere((state) => state is CreateInboxSuccess)
        .then((state) {
      setState(() {
        chat_id = (state as CreateInboxSuccess).chat_id;
      });
      _chatBloc.add(GetMessageEvent(chat_id!, currentMessagePage));
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
      const HomePage(),
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
        user_type: "COMMUTER",
      ),
    ];

    return BlocListener<AnnouncementBloc, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementLoading) {
          setState(() => isLoadingAnnouncement = true);
        } else if (state is GetAllAnnouncementsSuccess) {
          setState(() {
            announcements.addAll(state.announcements);
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

        //Navbar (from library?)
        child: Scaffold(
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Colors.white,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.map, 'Maps', 0),
                  _buildNavItem(Icons.inbox, 'Inbox', 1),
                  const SizedBox(width: 25),
                  _buildNavItem(Icons.campaign, 'Announcement', 2),
                  _buildNavItem(Icons.person, 'Profile', 3),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    title: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'SOS Alert',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your emergency SOS has been activated.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Emergency services have been notified with your location. Please stay calm and wait for assistance.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              print('SOS button pressed');
            },
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF00A2FF) : Colors.grey,
          ),
        ],
      ),
    );
  }
}
