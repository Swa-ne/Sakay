import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sakay_app/presentation/screens/admin/admin_inbox.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/admin/admin_notification.dart';
import 'package:sakay_app/presentation/screens/admin/admin_profile.dart';
import 'package:sakay_app/presentation/screens/admin/admin_surveillance.dart';

class AdminReports extends StatefulWidget {
  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  String? selectedFilter;
  String _selectedItem = "Report";

  void _removeNotification(NotificationItem notification) {
    setState(() {
      notifications.remove(notification);
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Bus Accident Report",
      message:
          "Accident occurred at Main Street intersection. Driver reported minor damage.",
      type: "Incident",
      time: "2 hours ago",
      isRead: false,
      details:
          "Bus #1045 was involved in a minor collision at the intersection of Main Street and 5th Avenue. No passengers were injured. Police report has been filed.",
      incidentLocation: "Main Street & 5th Avenue",
      incidentDate: "March 2, 2025",
      incidentTime: "10:45 AM",
      reportedBy: "John Smith",
      severity: "Minor",
    ),
    NotificationItem(
      title: "Driver Performance Review",
      message: "Monthly performance review for driver James Wilson.",
      type: "Performance",
      time: "3 hours ago",
      isRead: true,
      details:
          "Driver James Wilson has maintained excellent service standards this month. Passenger feedback has been overwhelmingly positive, with special mentions of his punctuality and courtesy.",
      driverName: "James Wilson",
      driverID: "DRV-2045",
      metrics: {
        "Service Rating": "4.8/5",
        "Driving Score": "92/100",
        "Reliability": "98%",
        "On-time Rate": "95%"
      },
      trend: "Improving",
      threshold: "4.5/5",
    ),
    NotificationItem(
      title: "Bus Maintenance Report",
      message: "Routine inspection for Bus #2034.",
      type: "Maintenance",
      time: "1 day ago",
      isRead: false,
      details:
          "Routine maintenance inspection completed for Bus #2034. Several issues were identified that require attention before the vehicle returns to service.",
      busID: "BUS-2034",
      maintenanceType: "Routine Inspection",
      scheduledStart: "March 1, 2025, 8:00 AM",
      scheduledEnd: "March 1, 2025, 11:00 AM",
      componentStatus: {
        "Front Wheels": "Normal",
        "Rear Wheels": "Defective - Tread wear",
        "Doors": "Normal",
        "Wipers": "Defective - Needs replacement",
        "Air Conditioner": "Normal",
        "Brakes": "Normal",
        "Lights": "Defective - Right signal light"
      },
    ),
    NotificationItem(
      title: "Highway Collision Report",
      message: "Bus #3056 involved in collision on Highway 101.",
      type: "Incident",
      time: "2 days ago",
      isRead: true,
      details:
          "Bus #3056 was involved in a collision with a sedan on Highway 101 northbound. Three passengers reported minor injuries and were treated at the scene. Highway patrol has filed a report.",
      incidentLocation: "Highway 101, Mile Marker 45",
      incidentDate: "February 28, 2025",
      incidentTime: "4:30 PM",
      reportedBy: "Sarah Johnson",
      severity: "Moderate",
    ),
    NotificationItem(
      title: "Driver Performance Alert",
      message: "Driver Michael Brown has received multiple complaints.",
      type: "Performance",
      time: "3 days ago",
      isRead: false,
      details:
          "Driver Michael Brown has received 5 passenger complaints in the past week regarding rude behavior and unsafe driving practices. Immediate supervisor intervention is recommended.",
      driverName: "Michael Brown",
      driverID: "DRV-1089",
      metrics: {
        "Service Rating": "2.3/5",
        "Driving Score": "65/100",
        "Reliability": "78%",
        "On-time Rate": "82%"
      },
      trend: "Declining",
      threshold: "3.0/5",
    ),
    NotificationItem(
      title: "Emergency Maintenance Required",
      message: "Bus #1078 requires immediate brake system inspection.",
      type: "Maintenance",
      time: "4 days ago",
      isRead: true,
      details:
          "Driver reported unusual brake behavior on Bus #1078. Emergency maintenance inspection required before vehicle can return to service.",
      busID: "BUS-1078",
      maintenanceType: "Emergency Inspection",
      scheduledStart: "February 27, 2025, 1:00 PM",
      scheduledEnd: "February 27, 2025, 5:00 PM",
      componentStatus: {
        "Front Wheels": "Normal",
        "Rear Wheels": "Normal",
        "Doors": "Normal",
        "Wipers": "Normal",
        "Air Conditioner": "Normal",
        "Brakes": "Defective - Requires immediate attention",
        "Lights": "Normal"
      },
    ),
    NotificationItem(
      title: "Driver Performance Excellence",
      message: "Driver Lisa Chen has received outstanding passenger reviews.",
      type: "Performance",
      time: "5 days ago",
      isRead: false,
      details:
          "Driver Lisa Chen has consistently received 5-star ratings from passengers over the past month. Her excellent customer service and safe driving practices have been highlighted in multiple reviews.",
      driverName: "Lisa Chen",
      driverID: "DRV-3042",
      metrics: {
        "Service Rating": "4.9/5",
        "Driving Score": "98/100",
        "Reliability": "100%",
        "On-time Rate": "97%"
      },
      trend: "Stable",
      threshold: "4.5/5",
    ),
  ];

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == null) {
      return notifications;
    }
    return notifications
        .where((notification) => notification.type == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF00A3FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/bus.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const Center(
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(color: Colors.white, thickness: 1),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Map";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminMap()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.map,
                        text: "Map",
                        isSelected: _selectedItem == "Map",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Surveillance";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminSurveillance()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.camera,
                        text: "Surveillance",
                        isSelected: _selectedItem == "Surveillance",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Report";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminReports()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.bar_chart,
                        text: "Report",
                        isSelected: _selectedItem == "Report",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Notifications";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminNotification()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.notifications,
                        text: "Notifications",
                        isSelected: _selectedItem == "Notifications",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Inbox";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminInbox()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.inbox,
                        text: "Inbox",
                        isSelected: _selectedItem == "Inbox",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedItem = "Profile";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminProfile()),
                        );
                      },
                      child: DrawerItem(
                        icon: Icons.person,
                        text: "Profile",
                        isSelected: _selectedItem == "Profile",
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  isSelected: _selectedItem == "Logout",
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A3FF),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: _openDrawer,
          ),
        ),
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Filter notifications',
            onSelected: (String value) {
              setState(() {
                selectedFilter = value == 'All' ? null : value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: ListTile(
                  leading:
                      Icon(Icons.notifications, color: Colors.black, size: 25),
                  title: Text('All Notifications'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Incident',
                child: ListTile(
                  leading: Icon(Icons.warning, color: Colors.red, size: 25),
                  title: Text('Incident Reports'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Performance',
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.orange, size: 25),
                  title: Text('Performance Reports'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Maintenance',
                child: ListTile(
                  leading: Icon(Icons.build, color: Colors.blue, size: 25),
                  title: Text('Maintenance Reports'),
                ),
              ),
            ],
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          if (selectedFilter != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Filtered by: $selectedFilter',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                    child: const Text('Clear Filter',
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: filteredNotifications.isEmpty
                ? const Center(
                    child: Text('No notifications found'),
                  )
                : ListView.separated(
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () {
                          if (notification.type == 'Incident') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IncidentReportPage(
                                  notification: notification,
                                  onMarkAsRead: () =>
                                      _removeNotification(notification),
                                ),
                              ),
                            );
                          } else if (notification.type == 'Performance') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PerformanceReportPage(
                                  notification: notification,
                                  onMarkAsRead: () =>
                                      _removeNotification(notification),
                                ),
                              ),
                            );
                          } else if (notification.type == 'Maintenance') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaintenanceReportPage(
                                  notification: notification,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: isSelected ? 40 : 50,
          width: isSelected ? 350 : 250,
          padding: isSelected
              ? const EdgeInsets.only(left: 10)
              : const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 30),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(notification.type),
        child: Icon(
          _getTypeIcon(notification.type),
          color: Colors.white,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(notification.message, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(notification.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  notification.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getTypeColor(notification.type),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                notification.time,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: onTap,
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Incident':
        return Colors.red;
      case 'Performance':
        return Colors.orange;
      case 'Maintenance':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Incident':
        return Icons.warning;
      case 'Performance':
        return Icons.person;
      case 'Maintenance':
        return Icons.build;
      default:
        return Icons.notifications;
    }
  }
}

// base report page
class GenericReportPage extends StatelessWidget {
  final NotificationItem notification;

  const GenericReportPage({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${notification.type} Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Reported: ${notification.time}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// incident report page
class IncidentReportPage extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMarkAsRead;

  const IncidentReportPage({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Accident Report'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.red.shade50,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning,
                                color: Colors.red, size: 32),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                notification.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            'Severity: ${notification.severity ?? "Unknown"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          notification.message,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.details, color: Colors.red, size: 25),
                            SizedBox(width: 5),
                            Text(
                              'Accident Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              notification.details ?? 'No details available',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Row(
                          children: [
                            Icon(Icons.info, color: Colors.red, size: 25),
                            SizedBox(width: 5),
                            Text(
                              'Incident Information',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildInfoRow(Icons.location_on, 'Location',
                                    notification.incidentLocation ?? 'Unknown'),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.calendar_today, 'Date',
                                    notification.incidentDate ?? 'Unknown'),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.access_time, 'Time',
                                    notification.incidentTime ?? 'Unknown'),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.person, 'Reported By',
                                    notification.reportedBy ?? 'Unknown'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                icon:
                    const Icon(Icons.read_more, color: Colors.white, size: 25),
                label: const Text('Mark as read'),
                onPressed: () {
                  onMarkAsRead();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.red.shade300, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// performance report page
class PerformanceReportPage extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMarkAsRead;

  const PerformanceReportPage({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('Driver Performance Report',
            style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.orange.shade50,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.orange, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.driverName ?? 'Unknown Driver',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${notification.driverID ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTrendColor(notification.trend),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTrendIcon(notification.trend),
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Performance: ${notification.trend ?? "Stable"}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.summarize, color: Colors.orange, size: 25),
                      SizedBox(width: 5),
                      Text(
                        'Performance Summary',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        notification.details ?? 'No details available',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.show_chart, color: Colors.orange, size: 25),
                      SizedBox(width: 5),
                      Text(
                        'Performance Metrics',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (notification.metrics != null)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: notification.metrics!.length,
                      itemBuilder: (context, index) {
                        String key =
                            notification.metrics!.keys.elementAt(index);
                        String value = notification.metrics![key]!;
                        return Card(
                          color: Colors.orange.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  value,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    const Text('No metrics available'),
                  const SizedBox(height: 20),
                  if (notification.threshold != null)
                    Card(
                      color: Colors.orange.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber,
                                color: Colors.deepOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Performance Threshold',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                      'Minimum Expected Rating: ${notification.threshold}',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.grey, size: 25),
                      const SizedBox(width: 8),
                      Text(
                        'Report Generated: ${notification.time}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: const Text('Contact Driver'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening messaging interface...'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      icon: const Icon(
                        Icons.read_more,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: const Text('Mark as read'),
                      onPressed: () {
                        onMarkAsRead();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrendColor(String? trend) {
    switch (trend) {
      case 'Declining':
        return Colors.red;
      case 'Improving':
        return Colors.green;
      case 'Stable':
      default:
        return Colors.blue;
    }
  }

  IconData _getTrendIcon(String? trend) {
    switch (trend) {
      case 'Declining':
        return Icons.trending_down;
      case 'Improving':
        return Icons.trending_up;
      case 'Stable':
      default:
        return Icons.trending_flat;
    }
  }
}

// maintenance report page
class MaintenanceReportPage extends StatelessWidget {
  final NotificationItem notification;

  const MaintenanceReportPage({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Bus Maintenance Report'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue.shade50,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.build, color: Colors.blue, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bus ID: ${notification.busID ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      notification.maintenanceType ?? 'Routine Maintenance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.content_paste_go_rounded,
                          color: Colors.black, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Component Status',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (notification.componentStatus != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notification.componentStatus!.length,
                      itemBuilder: (context, index) {
                        String component =
                            notification.componentStatus!.keys.elementAt(index);
                        String status =
                            notification.componentStatus![component]!;
                        bool isDefective =
                            status.toLowerCase().contains('defective');

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              isDefective
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: isDefective ? Colors.red : Colors.green,
                            ),
                            title: Text(
                              component,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              status,
                              style: const TextStyle(fontSize: 12),
                            ),
                            tileColor: isDefective
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                          ),
                        );
                      },
                    )
                  else
                  const Text('No component status available'),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.grey, size: 25),
                      const SizedBox(width: 8),
                      Text(
                        'Report Generated: ${notification.time}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
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

class AdminResponse {
  final String status;
  final String? assignedTo;
  final DateTime responseTime;
  final String? notes;
  final String? action;

  AdminResponse({
    required this.status,
    this.assignedTo,
    required this.responseTime,
    this.notes,
    this.action,
  });
}

class NotificationItem {
  final AdminResponse? adminResponse;

  final String title;
  final String message;
  final String type;
  final String time;
  final bool isRead;
  final String? details;

  // incident Reports
  final String? incidentLocation;
  final String? incidentDate;
  final String? incidentTime;
  final String? severity;
  final String? reportedBy;

  // performance Reports
  final String? driverName;
  final String? driverID;
  final Map<String, String>? metrics;
  final String? trend;
  final String? threshold;

  // maintenance Reports
  final String? busID;
  final String? scheduledStart;
  final String? scheduledEnd;
  final String? maintenanceType;
  final Map<String, String>? componentStatus;
  final List<String>? affectedSystems;
  final List<String>? affectedServices;

  NotificationItem({
    this.adminResponse,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
    this.details,
    this.incidentLocation,
    this.incidentDate,
    this.incidentTime,
    this.severity,
    this.reportedBy,
    this.driverName,
    this.driverID,
    this.metrics,
    this.trend,
    this.threshold,
    this.busID,
    this.scheduledStart,
    this.scheduledEnd,
    this.maintenanceType,
    this.componentStatus,
    this.affectedSystems,
    this.affectedServices,
  });
}

void showDriverContactDialog(
    BuildContext context, NotificationItem notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Contact Driver'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call Driver'),
            onTap: () {
              Navigator.pop(context);
              // call function
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Send Message'),
            onTap: () {
              Navigator.pop(context);
              // messaging function
            },
          ),
        ],
      ),
    ),
  );
}

void showPassengerListDialog(
    BuildContext context, NotificationItem notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Affected Passengers'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // passenger list
          ListTile(
            title: const Text('John Doe'),
            subtitle: const Text('Minor injuries'),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // call function
              },
            ),
          ),
          // add more passengers as needed
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// PerformanceReportPage
void showFeedbackDialog(BuildContext context, NotificationItem notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Send Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'Feedback Message',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Priority: '),
              DropdownButton<String>(
                value: 'normal',
                items: const [
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                ],
                onChanged: (value) {
                  // priority selection
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            //  feedback sending
          },
          child: const Text('Send'),
        ),
      ],
    ),
  );
}

// MaintenanceReportPage
void showRepairSchedulingDialog(
    BuildContext context, NotificationItem notification) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Schedule Repairs'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // date picker
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Select Date'),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
            },
          ),
          // time picker
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Select Time'),
            onTap: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
            },
          ),
          // technician assignment
          const TextField(
            decoration: InputDecoration(
              labelText: 'Assign Technician',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // implement repair scheduling
          },
          child: const Text('Schedule'),
        ),
      ],
    ),
  );
}
