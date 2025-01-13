import 'package:flutter/material.dart';
import 'package:sakay_app/screens/intro/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sakay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sakay"),
      ),
      body: const Center(
        child: Text(
          "Welcome to the Home Screen!",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
