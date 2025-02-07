import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return NotificationItem(
            title: index % 2 == 0
                ? 'Driver Verification Details'
                : 'PWD Verification Details',
            description: 'See uploaded files',
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;

  const NotificationItem(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsScreen(),
  ));
}
