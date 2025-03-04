import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_event.dart';
import 'package:sakay_app/bloc/chat/chat_state.dart';
import 'package:sakay_app/bloc/announcement/announcement_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_event.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/common/widgets/drawer_item.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';
import 'package:sakay_app/presentation/screens/admin/admin_bus_assign.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_announcement.dart';
import 'package:sakay_app/presentation/screens/admin/admin_report.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';
import 'package:sakay_app/presentation/screens/common/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Tracker {
  late TrackerBloc _trackerBloc;
  late AnnouncementBloc _announcementBloc;
  late ChatBloc _chatBloc;
  final TokenControllerImpl _tokenController = TokenControllerImpl();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String fullName = "";
  String profile = "";

  @override
  void initState() {
    super.initState();
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    initializeAsync();
    _chatBloc.add(ConnectRealtimeEvent());
    _announcementBloc.add(ConnectAnnouncementRealtimeEvent());
    _chatBloc.stream
        .firstWhere((state) => state is ConnectedRealtimeSocket)
        .then((_) {
      _chatBloc.add(ConnectAdminEvent());
    });
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);
    _trackerBloc.add(ConnectEvent());
  }

  Future<void> initializeAsync() async {
    String firstName = await _tokenController.getFirstName();
    String lastName = await _tokenController.getLastName();
    String profileUrl = await _tokenController.getProfile();

    setState(() {
      fullName = "$firstName $lastName";
      profile = profileUrl;
    });
  }

  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminMap(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminSurveillance(
          openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminDriverAssign(
          openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminReports(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminAnnouncement(
          openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      AdminInbox(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ProfilePage(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        user_type: "ADMIN",
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A3FF), Color(0xFF0066CC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profile,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                              'assets/profile.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...List.generate(7, (index) {
                      List<String> titles = [
                        "Map",
                        "Surveillance",
                        "Management",
                        "Report",
                        "Announcements",
                        "Inbox",
                        "Profile"
                      ];
                      List<IconData> icons = [
                        Icons.map,
                        Icons.camera,
                        Icons.directions_bus,
                        Icons.bar_chart,
                        Icons.campaign,
                        Icons.inbox,
                        Icons.person
                      ];
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedItem = index);
                          Navigator.pop(context);
                        },
                        child: DrawerItem(
                          icon: icons[index],
                          text: titles[index],
                          isSelected: _selectedItem == index,
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: pages[_selectedItem],
      ),
    );
  }
}
