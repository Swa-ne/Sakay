import 'package:flutter/material.dart';
import 'package:sakay_app/screens/authentication/usertype.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0), // Adjusted to match the space after the app bar
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                "Tell us about yourself",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 30.0),

              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person, color: Color(0xFF3A6C8D)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person, color: Color(0xFF3A6C8D)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/phflag.png',
                            height: 15.0,
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            "+63",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter mobile number',
                          hintStyle: TextStyle(fontWeight: FontWeight.normal),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              Row(
                children: [
                  Checkbox(
                    value: _isTermsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTermsAccepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isTermsAccepted = !_isTermsAccepted;
                        });
                      },
                      child: const Text(
                        "I agree to the Privacy Notice and Terms and Conditions",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: _isTermsAccepted
                    ? () {
                        Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserTypePage(firstName: '',)),
                  );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A6C8D),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
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
