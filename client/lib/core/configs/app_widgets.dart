import 'package:flutter/material.dart';

class Gradient extends StatelessWidget {
  const Gradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 255, 255, 255),
        Color(0xff2E3E4A),
      ])),
    );
  }
}
