import 'dart:async';
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

  bool get _isFormValid {
    bool passwordsMatch = _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text;

    return emailError == null &&
        confirmPasswordError == null &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _hasLowerCase &&
        _hasUpperCase &&
        _hasDigit &&
        _hasSpecialCharacter &&
        _isLongEnough &&
        passwordsMatch;
  }

  void _handleSubmit() {
    if (!_isFormValid) return;

    final signupData = SignUpUserModel(
      email_address: _emailController.text.trim(),
      password_hash: _passwordController.text,
      confirmation_password: _confirmPasswordController.text,
    );

    context.push("/signup2", extra: signupData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40.0),
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      if (_debounceEmail?.isActive ?? false) {
                        _debounceEmail?.cancel();
                      }
                      _debounceEmail = Timer(debounceDurationEmail, () async {
                        String? validationError =
                            await validateEmailInUse(text);
                        setState(() {
                          emailError = validationError;
                        });
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(fontSize: 13.0),
                      errorText: emailError,
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF00A2FF)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A2FF), width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Password
                  TextField(
                    controller: _passwordController,
                    onChanged: (text) {
                      _validatePassword(text);
                      if (_confirmPasswordController.text.isNotEmpty) {
                        String? validationError = validateConfirmPassword(
                            text, _confirmPasswordController.text);
                        setState(() {
                          confirmPasswordError = validationError;
                        });
                      }
                    },
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontSize: 13.0),
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF00A2FF),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A2FF), width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Password Requirements
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.security,
                                color: Color(0xFF00A2FF), size: 18.0),
                            const SizedBox(width: 8.0),
                            Text(
                              'Password Requirements',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        _buildPasswordCriteria(
                            'Contains lowercase letter (a-z)', _hasLowerCase),
                        _buildPasswordCriteria(
                            'Contains uppercase letter (A-Z)', _hasUpperCase),
                        _buildPasswordCriteria(
                            'Contains at least one digit (0-9)', _hasDigit),
                        _buildPasswordCriteria(
                            'Contains special character', _hasSpecialCharacter),
                        _buildPasswordCriteria(
                            'At least 8 characters long', _isLongEnough),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Confirm Password
                  TextField(
                    controller: _confirmPasswordController,
                    onChanged: (text) {
                      if (_debounceConfirmPassword?.isActive ?? false) {
                        _debounceConfirmPassword?.cancel();
                      }
                      _debounceConfirmPassword =
                          Timer(debounceDurationConfirmPassword, () async {
                        String? validationError = validateConfirmPassword(
                            _passwordController.text, text);
                        setState(() {
                          confirmPasswordError = validationError;
                        });
                      });
                    },
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(fontSize: 13.0),
                      errorText: confirmPasswordError,
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF00A2FF)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF00A2FF),
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF00A2FF), width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Next button
                  ElevatedButton(
                    onPressed: _isFormValid ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? const Color(0xFF00A2FF)
                          : Colors.grey.shade400,
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
                  const SizedBox(height: 20.0),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?  ",
                        style: TextStyle(fontSize: 13.0),
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
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCriteria(String text, bool isMet) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isMet ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isMet ? Colors.green.shade200 : Colors.red.shade200,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? Colors.green : Colors.red.shade400,
            ),
            child: Icon(
              isMet ? Icons.check : Icons.close,
              color: Colors.white,
              size: 14.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                color: isMet ? Colors.green.shade700 : Colors.red.shade600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (isMet)
            Icon(Icons.verified, color: Colors.green.shade600, size: 16.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _debounceEmail?.cancel();
    _debounceConfirmPassword?.cancel();
    super.dispose();
  }
}
