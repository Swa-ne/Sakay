import 'package:flutter/material.dart';

class TrackerRequiredPopup extends StatelessWidget {
  final double s;

  const TrackerRequiredPopup({Key? key, required this.s}) : super(key: key);

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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 40 * s,
              color: Colors.orange,
            ),
            SizedBox(height: 16 * s),
            Text(
              "Location Tracking Required",
              style: TextStyle(
                fontSize: 18 * s,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12 * s),
            Text(
              "Please enable location tracking to search for routes and destinations.",
              style: TextStyle(
                fontSize: 14 * s,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20 * s),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
