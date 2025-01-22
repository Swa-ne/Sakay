import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sakay_app/screens/authentication/login_page.dart';
import 'package:sakay_app/screens/authentication/register_page.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70.0),
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              const Text(
                "Create a new account.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 30.0),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF00A2FF)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF00A2FF),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; 
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF00A2FF),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FF),
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

              const SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?  ",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF00A2FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30.0),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                  },
                  icon: Image.asset('assets/google_icon.png', height: 24.0),
                  label: const Text('Sign up with Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120.0),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: "By signing up you agree to our ",
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Terms of Use",
                        style: const TextStyle(color: Color(0xFF00A2FF)),
                        recognizer: TapGestureRecognizer()..onTap = () {
                        },
                      ),
                      const TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(color: Color(0xFF00A2FF)),
                        recognizer: TapGestureRecognizer()..onTap = () {
                        },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

