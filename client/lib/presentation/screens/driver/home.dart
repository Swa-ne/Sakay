import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_event.dart';
import 'package:sakay_app/bloc/tracker/tracker_state.dart';
import 'package:sakay_app/common/mixins/tracker.dart';
import 'package:sakay_app/presentation/screens/common/inbox.dart';
import 'package:sakay_app/presentation/screens/common/notifications.dart';
import 'package:sakay_app/presentation/screens/driver/homepage.dart';
import '../common/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Tracker {
  late TrackerBloc _trackerBloc;

  @override
  void initState() {
    super.initState();
    _trackerBloc = BlocProvider.of<TrackerBloc>(context);

    _trackerBloc.add(ConnectEvent());
    _trackerBloc.stream
        .firstWhere((state) => state is ConnectedSocket)
        .then((_) {
      _trackerBloc.add(ConnectDriverEvent());
    });
  }

  int _selectedIndex = 0;

  final pages = [
    const HomePage(),
    const InboxScreen(),
    const NotificationsScreen(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
