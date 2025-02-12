import 'package:flutter/material.dart';
import '../commuters/profile.dart';
import 'notifications.dart';
import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inbox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InboxScreen(),
    );
  }
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<InboxItem> inboxItems = [
    InboxItem(sender: 'Emmanuel Darude', message: 'Yung driver bigla bigla nagppreno parang wan....', time: '4:14 pm'),
    InboxItem(sender: 'Emmanuel Darude', message: 'Grabe, ambilis ng magpatakbo ni kuya driver', time: '12:22 pm'),
    InboxItem(sender: 'Emmanuel Darude', message: 'Nagugstomako', time: '9:41 am'),
    InboxItem(sender: 'Emmanuel Darude', message: 'Clpo with a gravyy', time: '12:22 pm'),
  ];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      final pages = [const HomePage(), const InboxScreen(), const NotificationsScreen(), const ProfilePage()];
      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => pages[index],
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inboxItems.length,
              itemBuilder: (context, index) {
                return InboxItemWidget(inboxItems[index]);
              },
            ),
          ),
        ],
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class InboxItem {
  final String sender;
  final String message;
  final String time;

  InboxItem({required this.sender, required this.message, required this.time});
}

class InboxItemWidget extends StatelessWidget {
  final InboxItem item;

  const InboxItemWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(item.sender),
        subtitle: Text(item.message),
        trailing: Text(item.time),
      ),
    );
  }
}
