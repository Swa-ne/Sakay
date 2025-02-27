import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportsScreen(),
    );
  }
}

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedReport = "Performance Report";

  Widget getReportScreen() {
    switch (selectedReport) {
      case "Incident Report":
        return reportContent("Incident Report");
      case "Maintenance Report":
        return reportContent("Maintenance Report");
      default:
        return reportContent("Performance Report");
    }
  }

  Widget reportContent(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.warning, color: Colors.white),
              ),
              title: Text(
                "UNIT-72K",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("See report details"),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {},
                      ),
                      menuItem("Incident Report", Icons.car_repair),
                      menuItem("Performance Report", Icons.article),
                      menuItem("Maintenance Report", Icons.settings),
                    ],
                  ),
                ),
                Expanded(child: getReportScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Radio<String>(
        value: title,
        groupValue: selectedReport,
        onChanged: (value) {
          setState(() {
            selectedReport = value!;
          });
        },
      ),
    );
  }
}
