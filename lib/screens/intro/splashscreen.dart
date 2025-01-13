import 'package:flutter/material.dart';
import 'package:sakay_app/screens/intro/guide_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GuideScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sakaylogo.png',
              height: 400.0,
            ),
            const SizedBox(height: 20.0),
            // Styled CircularProgressIndicator with custom color
            const CircularProgressIndicator(
              color: Color(0xFF3A6C8D), 
            ),
          ],
        ),
      ),
    );
  }
}
