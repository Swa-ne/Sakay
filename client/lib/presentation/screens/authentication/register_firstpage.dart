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
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

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
    // Check if passwords match
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
        passwordsMatch &&
        _termsAccepted &&
        _privacyAccepted;
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('📄 Terms & Conditions'),
          content: const SingleChildScrollView(
            child: Text(
              '''Terms and Conditions

By agreeing to these Terms and Conditions, you acknowledge and accept the following:

1. Usage of Sakay
Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route. The app is intended for UPang students, daily commuters, PWDs, and registered drivers.

2. Account & Access
Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features based on their account type.

3. Data Collection
By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication and communication purposes. We do not sell or share your information with third parties.

4. Announcements & Communication
Admins may post important announcements which are visible to users through the app. These may include service updates, route adjustments, or general notices relevant to the Sakay system.

5. Service Availability
While we aim to provide real-time, accurate vehicle data, Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect real-time tracking at times.

6. Acceptable Use
Users must not attempt to disrupt the service, misuse data, or impersonate others. Abuse or suspicious activity may result in account restriction.

7. Changes to Terms
We may update these Terms and Conditions as the service evolves. Users will be notified of significant changes through the app.

8. Contact & Support
For questions, feedback, or issues, please reach out through our admin portal or the official Sakay website.''',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('🔒 Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              '''1. Information We Collect
We collect information you directly provide when:
• Creating an account
• Using the app's features
• Contacting support

2. How We Use Your Information
Your data is used to:
• Provide and improve the Sakay app
• Process logins and activity
• Send important service or support messages
• Communicate updates and relevant information

3. Information Sharing
We do not sell, trade, or share your personal data with third parties without your consent, except as required by law.

4. Data Security
We implement appropriate security practices to protect your data from unauthorized access, alteration, or misuse.

5. Data Retention
Your information is retained as long as your account is active or as needed for app functionality and safety.

6. Your Rights
You have the right to:
• View your personal data
• Request corrections
• Delete your account
• Withdraw consent for data use

7. Cookies & Analytics
We may use cookies and similar technologies to enhance your experience and track usage patterns for analytics.

8. Changes to Policy
This Privacy Policy may be updated as necessary. Users will be notified of changes via in-app alerts or on this page.''',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    // Final validation before submission
    if (!_isFormValid) {
      return;
    }

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
              const SizedBox(height: 0.0),
              const Text(
                "Create a new account.",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
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
                  labelStyle: const TextStyle(fontSize: 13.0),
                  errorText: emailError,
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF00A2FF)),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: _passwordController,
                onChanged: (text) {
                  _validatePassword(text);
                  // Re-validate confirm password when password changes
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
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF00A2FF)),
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
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 3.0),
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
                        const Icon(
                          Icons.security,
                          color: Color(0xFF00A2FF),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Password Requirements',
                          style: TextStyle(
                            fontSize: 14.0,
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
                        'Contains special character (!@#\$%^&*)',
                        _hasSpecialCharacter),
                    _buildPasswordCriteria(
                        'At least 8 characters long', _isLongEnough),
                  ],
                ),
              ),
              const SizedBox(height: 3.0),
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
                  labelStyle: const TextStyle(fontSize: 13.0),
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
              const SizedBox(height: 20.0),
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
            ],
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
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
                color: isMet ? Colors.green.shade700 : Colors.red.shade600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (isMet)
            Icon(
              Icons.verified,
              color: Colors.green.shade600,
              size: 16.0,
            ),
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