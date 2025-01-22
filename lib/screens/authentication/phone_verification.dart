import 'package:flutter/material.dart';
import 'package:sakay_app/screens/authentication/phone_verification_code.dart';

class PhoneVerificationPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();

  PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 130.0),
              Center(
                child: Image.asset(
                  'assets/sakay_logo.png',
                  height: 100.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10.0),

              const Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),

              const Text(
                "We need to register your phone number before getting started",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35.0),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/phflag.png',
                          height: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          "+63",
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),

                    Expanded(
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),

              ElevatedButton(
                onPressed: () {
                  if (_phoneNumberController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneVerificationCodePage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter your phone number'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FF),
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 145.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "Send Code",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
