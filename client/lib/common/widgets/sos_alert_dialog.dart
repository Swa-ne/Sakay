import 'package:flutter/material.dart';

class SosAlertDialog extends StatelessWidget {
  final String commuterName;
  const SosAlertDialog({super.key, required this.commuterName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("🚨 SOS Alert!"),
      content: Text("Commuter $commuterName has triggered an SOS!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Acknowledge"),
        ),
      ],
    );
  }
}