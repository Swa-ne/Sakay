import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/commuters/current_location.dart';

class UserTypePage extends StatefulWidget {
  final String firstName;

  const UserTypePage({super.key, required this.firstName});

  @override
  _UserTypePageState createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  String? _userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage(
                  'assets/profile.jpg'), // Change to your image asset
            ),
            const SizedBox(height: 20.0),
            Text(
              "Hey, ${widget.firstName}",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            const Text(
              "What type of user are you?",
              style: TextStyle(fontSize: 15.0),
            ),
            const SizedBox(height: 50.0),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Commuter',
                        groupValue: _userType,
                        onChanged: (String? value) {
                          setState(() {
                            _userType = value;
                          });
                        },
                      ),
                      const Text('Commuter'),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'PWD',
                        groupValue: _userType,
                        onChanged: (String? value) {
                          setState(() {
                            _userType = value;
                          });
                        },
                      ),
                      const Text('PWD'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: _userType != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CurrentLocationPage(),
                        ),
                      );
                    }
                  : null, // Disable if no selection
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6C8D),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 155.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
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
    );
  }
}
