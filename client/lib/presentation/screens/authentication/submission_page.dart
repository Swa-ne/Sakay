import 'package:flutter/material.dart';

class SubmissionSuccessfulPage extends StatelessWidget {
  const SubmissionSuccessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200.0),
            Center(
              child: Image.asset(
                'assets/check.png',
                height: 50.0,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30.0),

            const Text(
              "Submission Successful",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15.0),

            const Text(
              "Thank you for providing your documents. Please wait momentarily as we review them. Have a wonderful day!",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 250.0),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A2FF),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 150.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
