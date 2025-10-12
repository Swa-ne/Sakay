import 'package:flutter/material.dart';

class DestinationApproachingPopup extends StatelessWidget {
  final double s;
  final String destinationName;

  const DestinationApproachingPopup({
    Key? key,
    required this.s,
    required this.destinationName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20 * s),
      child: Container(
        padding: EdgeInsets.all(20 * s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16 * s),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10 * s,
              offset: Offset(0, 4 * s),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            Icon(
              Icons.notifications_active,
              size: 50 * s,
              color: Colors.orange,
            ),
            SizedBox(height: 16 * s),

            // Title
            Text(
              "Approaching Destination",
              style: TextStyle(
                fontSize: 18 * s,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12 * s),

            // Message with destination name
            Text(
              "You are 2km away from your destination:",
              style: TextStyle(
                fontSize: 14 * s,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8 * s),

            // Destination name highlight
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16 * s, vertical: 8 * s),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8 * s),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Text(
                destinationName,
                style: TextStyle(
                  fontSize: 16 * s,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20 * s),

            // OK button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 12 * s),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8 * s),
                  ),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(
                    fontSize: 16 * s,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
