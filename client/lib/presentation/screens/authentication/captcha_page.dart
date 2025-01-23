import 'dart:math';

import 'package:flutter/material.dart';

class CaptchaPage extends StatefulWidget {
  final VoidCallback onCaptchaVerified;

  const CaptchaPage({super.key, required this.onCaptchaVerified});

  @override
  _CaptchaPageState createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {
  final TextEditingController _captchaController = TextEditingController();
  String _captchaQuestion = "";
  String _captchaAnswer = "";
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    Random random = Random();
    int num1 = random.nextInt(50) + 1;
    int num2 = random.nextInt(50) + 1;
    _captchaQuestion = "$num1 + $num2 = ?";
    _captchaAnswer = (num1 + num2).toString();
  }

  void _validateCaptcha() {
    setState(() {
      if (_captchaController.text == _captchaAnswer) {
        _errorMessage = null;
        _showSuccessDialog();
      } else {
        _errorMessage = "Incorrect answer. Please try again.";
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("CAPTCHA solved successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              widget.onCaptchaVerified(); 
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'CAPTCHA',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            Text(
              _captchaQuestion,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _captchaController,
              decoration: InputDecoration(
                labelText: "Enter your answer",
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                ),
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _validateCaptcha,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                backgroundColor: const Color(0xFF00A2FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "Verify",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
