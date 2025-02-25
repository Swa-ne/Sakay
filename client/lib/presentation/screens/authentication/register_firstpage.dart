import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:sakay_app/data/models/sign_up.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage1> with InputValidationMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Timer? _debounceEmail;
  Timer? _debounceConfirmPassword;

  final Duration debounceDurationEmail = const Duration(milliseconds: 1250);
  final Duration debounceDurationPassword = const Duration(milliseconds: 1250);
  final Duration debounceDurationConfirmPassword =
      const Duration(milliseconds: 1250);

  String? emailError;
  String? confirmPasswordError;

  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasDigit = false;
  bool _isLongEnough = false;
  bool _hasSpecialCharacter = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _validatePassword(String password) {
    setState(() {
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasDigit = password.contains(RegExp(r'\d'));
      _hasSpecialCharacter =
          password.contains(RegExp(r'.*[!@#$%^&*(),.?":{}|<>].*'));
      _isLongEnough = password.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
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
                onChanged: (text) {
                  if (_debounceEmail?.isActive ?? false)
                    _debounceEmail?.cancel();
                  _debounceEmail = Timer(debounceDurationEmail, () async {
                    String? validationError = await validateEmailInUse(text);
                    setState(() {
                      emailError = validationError;
                    });
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailError,
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF00A2FF)),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                onChanged: (text) {
                  _validatePassword(text);
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF00A2FF),
                    ),
                    onPressed: () {
                      _validatePassword(_passwordController.text);
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPasswordCriteria('Lowercase letter', _hasLowerCase),
                  _buildPasswordCriteria('Uppercase letter', _hasUpperCase),
                  _buildPasswordCriteria('Digit', _hasDigit),
                  _buildPasswordCriteria(
                      'Special character', _hasSpecialCharacter),
                  _buildPasswordCriteria(
                      'At least 8 characters', _isLongEnough),
                ],
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _confirmPasswordController,
                onChanged: (text) {
                  if (_debounceConfirmPassword?.isActive ?? false)
                    _debounceConfirmPassword?.cancel();
                  _debounceConfirmPassword =
                      Timer(debounceDurationConfirmPassword, () async {
                    String? validationError =
                        validateConfirmPassword(_passwordController.text, text);
                    setState(() {
                      confirmPasswordError = validationError;
                    });
                  });
                },
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  errorText: confirmPasswordError,
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                    borderSide:
                        BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  String? isValidEmail = validateEmail(_emailController.text);
                  if (isValidEmail != null) {
                    setState(() {
                      emailError = isValidEmail;
                    });
                    return;
                  }
                  if (_confirmPasswordController.text.isEmpty) {
                    setState(() {
                      confirmPasswordError = "This field can't be empty";
                    });
                    return;
                  }
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    setState(() {
                      confirmPasswordError = "Doesn't match password";
                    });
                    return;
                  }
                  final signupData = SignUpUserModel(
                    email_address: _emailController.text,
                    password_hash: _passwordController.text,
                    confirmation_password: _confirmPasswordController.text,
                  );
                  context.push("/signup2", extra: signupData);
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
                      context.go('/login');
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
                  onPressed: () {},
                  icon: Image.asset('assets/google_icon.png', height: 24.0),
                  label: const Text('Sign up with Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 30.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: "By signing up you agree to our ",
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Terms of Use",
                        style: const TextStyle(color: Color(0xFF00A2FF)),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(color: Color(0xFF00A2FF)),
                        recognizer: TapGestureRecognizer()..onTap = () {},
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

  Widget _buildPasswordCriteria(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check : Icons.close,
          color: isMet ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            decoration:
                isMet ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}
