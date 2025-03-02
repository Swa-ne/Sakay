import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AdminNotification(),
    );
  }
}

class AdminNotification extends StatefulWidget {
  const AdminNotification({Key? key}) : super(key: key);

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  String? selectedFilter;
  
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Bus Accident Report",
      message: "Accident occurred at Main Street intersection. Driver reported minor damage.",
      type: "Incident",
      time: "2 hours ago",
      isRead: false,
      details: "Bus #1045 was involved in a minor collision at the intersection of Main Street and 5th Avenue. No passengers were injured. Police report has been filed.",
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
      details: "Driver James Wilson has maintained excellent service standards this month. Passenger feedback has been overwhelmingly positive, with special mentions of his punctuality and courtesy.",
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
      message: "Routine inspection completed for Bus #2034.",
      type: "Maintenance",
      time: "1 day ago",
      isRead: false,
      details: "Routine maintenance inspection completed for Bus #2034. Several issues were identified that require attention before the vehicle returns to service.",
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
      details: "Bus #3056 was involved in a collision with a sedan on Highway 101 northbound. Three passengers reported minor injuries and were treated at the scene. Highway patrol has filed a report.",
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
      details: "Driver Michael Brown has received 5 passenger complaints in the past week regarding rude behavior and unsafe driving practices. Immediate supervisor intervention is recommended.",
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
      details: "Driver reported unusual brake behavior on Bus #1078. Emergency maintenance inspection required before vehicle can return to service.",
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
      details: "Driver Lisa Chen has consistently received 5-star ratings from passengers over the past month. Her excellent customer service and safe driving practices have been highlighted in multiple reviews.",
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
    return notifications.where((notification) => notification.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // back
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Notifications'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter notifications',
            onSelected: (String value) {
              setState(() {
                selectedFilter = value == 'All' ? null : value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('All Notifications'),
              ),
              const PopupMenuItem<String>(
                value: 'Incident',
                child: Text('Incident Reports'),
              ),
              const PopupMenuItem<String>(
                value: 'Performance',
                child: Text('Performance Reports'),
              ),
              const PopupMenuItem<String>(
                value: 'Maintenance',
                child: Text('Maintenance Reports'),
              ),
            ],
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
                    child: const Text('Clear Filter'),
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
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return NotificationTile(notification: notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTile({
    Key? key,
    required this.notification,
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
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(notification.message),
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
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        Widget reportPage;
        switch (notification.type) {
          case 'Incident':
            reportPage = IncidentReportPage(notification: notification);
            break;
          case 'Performance':
            reportPage = PerformanceReportPage(notification: notification);
            break;
          case 'Maintenance':
            reportPage = MaintenanceReportPage(notification: notification);
            break;
          default:
            reportPage = GenericReportPage(notification: notification);
        }
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => reportPage),
        );
      },
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
  
  const GenericReportPage({Key? key, required this.notification}) : super(key: key);
  
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
  
  const IncidentReportPage({Key? key, required this.notification}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text('Accident Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing accident report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                      const Icon(Icons.warning, color: Colors.red, size: 32),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Severity: ${notification.severity ?? "Unknown"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 16,
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
                  const Text(
                    'Accident Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        notification.details ?? 'No details available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Incident Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.location_on, 'Location', notification.incidentLocation ?? 'Unknown'),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.calendar_today, 'Date', notification.incidentDate ?? 'Unknown'),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.access_time, 'Time', notification.incidentTime ?? 'Unknown'),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.person, 'Reported By', notification.reportedBy ?? 'Unknown'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.file_copy),
                      label: const Text('Generate Full Report'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Generating full accident report...')),
                        );
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
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.red.shade300, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
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
  
  const PerformanceReportPage({Key? key, required this.notification}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('Driver Performance Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading performance data...')),
              );
            },
          ),
        ],
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${notification.driverID ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 14,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTrendColor(notification.trend),
                      borderRadius: BorderRadius.circular(16),
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
                      fontSize: 16,
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
                  const Text(
                    'Performance Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        notification.details ?? 'No details available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Performance Metrics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (notification.metrics != null)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: notification.metrics!.length,
                      itemBuilder: (context, index) {
                        String key = notification.metrics!.keys.elementAt(index);
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
                                    fontSize: 20,
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
                  const SizedBox(height: 24),
                  if (notification.threshold != null)
                    Card(
                      color: Colors.orange.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber, color: Colors.deepOrange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Performance Threshold',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Minimum Expected Rating: ${notification.threshold}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // mock performance chart
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomPaint(
                      painter: PerformanceChartPainter(),
                      child: const Center(
                        child: Text('Performance Trend (Last 3 Months)'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Report Generated: ${notification.time}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text('Contact Driver'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening messaging interface...')),
                        );
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

// custom painter for mock performance chart
class PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    path.moveTo(0, size.height * 0.5);
  
    path.lineTo(size.width * 0.1, size.height * 0.6);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.3);
    
    canvas.drawPath(path, paint);
    
    final thresholdPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final dashWidth = 5;
    final dashSpace = 5;
    double startX = 0;
    final thresholdY = size.height * 0.4;
    
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, thresholdY),
        Offset(startX + dashWidth, thresholdY),
        thresholdPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// maintenance report page
class MaintenanceReportPage extends StatelessWidget {
  final NotificationItem notification;
  
  const MaintenanceReportPage({Key? key, required this.notification}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Bus Maintenance Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Printing maintenance report...')),
              );
            },
          ),
        ],
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bus ID: ${notification.busID ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 14,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      notification.maintenanceType ?? 'Routine Maintenance',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 16,
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
                  const Text(
                    'Maintenance Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        notification.details ?? 'No details available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Component Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (notification.componentStatus != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notification.componentStatus!.length,
                      itemBuilder: (context, index) {
                        String component = notification.componentStatus!.keys.elementAt(index);
                        String status = notification.componentStatus![component]!;
                        bool isDefective = status.toLowerCase().contains('defective');
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              isDefective ? Icons.error_outline : Icons.check_circle_outline,
                              color: isDefective ? Colors.red : Colors.green,
                            ),
                            title: Text(component),
                            subtitle: Text(status),
                            tileColor: isDefective ? Colors.red.shade50 : Colors.green.shade50,
                          ),
                        );
                      },
                    )
                  else
                    const Text('No component status available'),
                  const SizedBox(height: 24),
                  const Text(
                    'Maintenance Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.play_circle_outline, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Start Time',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      notification.scheduledStart ?? 'Not specified',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.stop_circle_outlined, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'End Time',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      notification.scheduledEnd ?? 'Not specified',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const LinearProgressIndicator(
                            value: 1.0, // Completed
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Status: Completed',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Report Generated: ${notification.time}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.schedule),
                      label: const Text('Schedule Follow-up'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening scheduling interface...')),
                        );
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
  
  // Incident Reports
  final String? incidentLocation;
  final String? incidentDate;
  final String? incidentTime;
  final String? severity;
  final String? reportedBy;
  
  // Performance Reports
  final String? driverName;
  final String? driverID;
  final Map<String, String>? metrics;
  final String? trend;
  final String? threshold;
  
  // Maintenance Reports
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

void showDriverContactDialog(BuildContext context, NotificationItem notification) {
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

void showPassengerListDialog(BuildContext context, NotificationItem notification) {
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
void showRepairSchedulingDialog(BuildContext context, NotificationItem notification) {
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