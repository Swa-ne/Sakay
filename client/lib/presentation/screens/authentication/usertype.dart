import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/pwdrequirements_page.dart';
import 'captcha_page.dart';
import 'package:sakay_app/presentation/screens/authentication/phone_verification.dart';

class UserTypePage extends StatefulWidget {
  final String firstName;

  const UserTypePage({super.key, required this.firstName});

  @override
  _UserTypePageState createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  String? _userType;

  void _navigateToCaptcha() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptchaPage(
          onCaptchaVerified: () {
            if (_userType == 'Commuter') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PhoneVerificationPage()),
              );
            } else if (_userType == 'PWD') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PWDRequirementsPage()),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 20.0),
              Text(
                "Hey, ${widget.firstName}",
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15.0),
              const Text(
                "What type of user are you?",
                style: TextStyle(fontSize: 15.0),
              ),
              const SizedBox(height: 30.0),
              _buildUserTypeOption('Commuter'),
              const SizedBox(height: 10.0),
              _buildUserTypeOption('PWD'),
              const SizedBox(height: 10.0),
              _buildUserTypeOption('Driver'),
              const Spacer(),
              ElevatedButton(
                onPressed: _userType != null ? _navigateToCaptcha : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FF),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 145.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeOption(String userType) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Radio<String>(
            value: userType,
            groupValue: _userType,
            onChanged: (String? value) {
              setState(() {
                _userType = value;
              });
            },
          ),
          Text(userType),
        ],
      ),
    );
  }
}
