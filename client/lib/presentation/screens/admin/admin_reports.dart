import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 8),
                Text(
                  'Reports', 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ReportItem(
              icon: Icons.directions_car,
              title: 'Incident Report',
              description: 'Track and review unexpected events and actions taken',
            ),
            ReportItem(
              icon: Icons.library_books,
              title: 'Performance Report',
              description: 'Analyze key metrics and evaluate progress',
            ),
            ReportItem(
              icon: Icons.settings,
              title: 'Maintenance Report',
              description: 'Monitor scheduled upkeep and repair activities',
            ),
            ReportItem(
              icon: Icons.insert_chart,
              title: 'Custom Report',
              description: 'Generate tailored insights to meet specific needs',
            ),
          ],
        ),
      ),
    );
  }
}

class ReportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const ReportItem({
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Centers the icon vertically
            children: [
              Container(
                width: 40, // Ensures consistent spacing
                height: 40, // Adjusts height for centering
                alignment: Alignment.center, // Centers the icon
                child: Icon(icon, size: 30, color: Colors.black),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
