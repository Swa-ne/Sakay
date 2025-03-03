import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/bloc/notification/notification_bloc.dart';
import 'package:sakay_app/bloc/notification/notification_event.dart';
import 'package:sakay_app/bloc/notification/notification_state.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/data/models/message.dart';
import 'package:sakay_app/data/models/notificaton.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/common/inbox.dart';
import 'package:sakay_app/presentation/screens/common/notifications.dart';
import 'package:sakay_app/presentation/screens/commuters/homepage.dart';
import '../common/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Tracker {
  late TrackerBloc _trackerBloc;
  late NotificationBloc _notificationBloc;
  late ChatBloc _chatBloc;

  final TokenControllerImpl _tokenController = TokenControllerImpl();

  // Notifications
  final List<NotificationModel> notifications = [];
  int currentNotificationPage = 1;
  final ScrollController _scrollNotificationController = ScrollController();
  bool isLoadingNotification = false;

  // Messages
  final List<MessageModel> messages = [];
  int currentMessagePage = 1;
  final ScrollController _scrollMessageController = ScrollController();
  bool isLoadingMessage = false;

  late String user_id;
  String? chat_id;
  bool isLoadingUser = true;

  // Scroll Listeners
  void _onScrollNotification() {
    if (_scrollNotificationController.position.pixels <= 100 &&
        !isLoadingNotification) {
      setState(() {
        isLoadingNotification = true;
        currentNotificationPage++;
      });
      _notificationBloc.add(GetAllNotificationsEvent(currentNotificationPage));
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
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);

    _initializeUserID();
  }

  Future<void> _initializeUserID() async {
    user_id = await _tokenController.getUserID();
    setState(() => isLoadingUser = false);

    _chatBloc.add(ConnectRealtimeEvent());
    _notificationBloc.add(ConnectNotificationRealtimeEvent());
    _trackerBloc.add(ConnectEvent());

    _notificationBloc.stream
        .firstWhere((state) => state is ConnectedNotificationRealtimeSocket)
        .then((_) {
      _notificationBloc.add(GetAllNotificationsEvent(currentNotificationPage));
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

    _scrollNotificationController.addListener(_onScrollNotification);
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
      NotificationsScreen(
        notifications: notifications,
        scrollNotificationController: _scrollNotificationController,
        isLoadingNotification: isLoadingNotification,
      ),
      const ProfilePage(
        user_type: "COMMUTER",
      ),
    ];

    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoading) {
          setState(() => isLoadingNotification = true);
        } else if (state is GetAllNotificationsSuccess) {
          print("fjsadhfkjshkfhaskf ${state.notifications}");
          setState(() {
            notifications.addAll(state.notifications);
            isLoadingNotification = false;
          });
        } else if (state is OnReceiveNotificationSuccess) {
          // TODO: add simple notification like sa tiktok
          setState(() {
            notifications.insert(0, state.notification);
            isLoadingNotification = false;
          });
        } else if (state is GetAllNotificationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
          setState(() => isLoadingNotification = false);
        } else if (state is OnReceiveNotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
          setState(() => isLoadingNotification = false);
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
            // TODO: add simple notification like sa tiktok
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
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF00A2FF),
            unselectedItemColor: const Color(0xFF00A2FF),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
              BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'Notifications'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
