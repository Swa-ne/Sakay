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
  bool _acceptedTerms = false;
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
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    cursorColor: const Color(0xFF00A2FF), // 👈 cursor color
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
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF00A2FF),
                      ),
                      errorText: emailError,
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF00A2FF)),
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
                  const SizedBox(height: 10.0),

                  // Password
                  TextField(
                    controller: _passwordController,
                    cursorColor: const Color(0xFF00A2FF),
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
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF00A2FF),
                      ),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF00A2FF), width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Confirm Password
                  TextField(
                    controller: _confirmPasswordController,
                    cursorColor: const Color(0xFF00A2FF),
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
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF00A2FF),
                      ),
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
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        activeColor: const Color(0xFF00A2FF),
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show Terms & Conditions inside a bottom sheet
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (context) => DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.8,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                builder: (_, controller) =>
                                    SingleChildScrollView(
                                  controller: controller,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00A2FF)
                                                .withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: const Color(0xFF00A2FF)
                                                  .withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Text(
                                            'By agreeing to these Terms and Conditions, you acknowledge and accept the following:',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2D3748),
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        const _TermsSection(
                                          title: '1. Usage of Sakay',
                                          content:
                                              'Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route.',
                                          icon: Icons.directions_bus,
                                        ),
                                        const _TermsSection(
                                          title: '2. Account & Access',
                                          content:
                                              'Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features.',
                                          icon: Icons.account_circle,
                                        ),
                                        const _TermsSection(
                                          title: '3. Data Collection',
                                          content:
                                              'By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication.',
                                          icon: Icons.security,
                                        ),
                                        const _TermsSection(
                                          title:
                                              '4. Announcements & Communication',
                                          content:
                                              'Admins may post important announcements which are visible to users through the app.',
                                          icon: Icons.campaign,
                                        ),
                                        const _TermsSection(
                                          title: '5. Service Availability',
                                          content:
                                              'Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect tracking.',
                                          icon: Icons.wifi,
                                        ),
                                        const _TermsSection(
                                          title: '6. Acceptable Use',
                                          content:
                                              'Users must not attempt to disrupt the service, misuse data, or impersonate others.',
                                          icon: Icons.verified_user,
                                        ),
                                        const _TermsSection(
                                          title: '7. Changes to Terms',
                                          content:
                                              'We may update these Terms and Conditions as the service evolves.',
                                          icon: Icons.update,
                                        ),
                                        const _TermsSection(
                                          title: '8. Contact & Support',
                                          content:
                                              'For questions, feedback, or issues, please reach out through our admin portal.',
                                          icon: Icons.support_agent,
                                        ),
                                        const SizedBox(height: 32),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.grey.shade600,
                                                size: 24,
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                'Last updated: ${DateTime.now().year}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'These terms are effective immediately upon acceptance',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10.0),

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
                  const SizedBox(height: 10.0),

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

class _TermsSection extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _TermsSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A2FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: const Color(0xFF00A2FF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 11,
              height: 1.6,
              color: Color(0xFF4A5568),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
