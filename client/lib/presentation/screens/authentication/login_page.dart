import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/common/mixins/input_validation.dart';
import 'package:sakay_app/data/models/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with InputValidationMixin {
  bool _isPasswordVisible = false;
  late AuthBloc _authBloc;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  Timer? _debounceEmail;
  Timer? _debouncePassword;
  final Duration debounceDurationEmail = const Duration(milliseconds: 1250);
  final Duration debounceDurationPassword = const Duration(milliseconds: 1250);
  bool _isRememberMeChecked = false;
  String? emailError;
  String? passwordError;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Show Terms and Conditions dialog when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTermsAndConditionsDialog();
    });
  }

  Future<void> _showTermsAndConditionsDialog() async {
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _TermsAndConditionsDialog();
      },
    );

    if (agreed == true) {
      setState(() {
        _termsAccepted = true;
      });
    } else {
      // If user doesn't accept terms, you might want to close the app or navigate back
      // For now, we'll just keep showing the dialog
      _showTermsAndConditionsDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is EmailNotVerified) {
          _authBloc.add(ResendEmailCodeEvent(state.token));
          context.go("/email_verification", extra: {
            "email_address": obfuscateEmail(_emailController.text),
            "token": state.token,
          });
        } else if (state is LoginError) {
          setState(() {
            emailError = "Incorrect Email or Password";
            passwordError = "Incorrect Email or Password";
          });
        }
        if (state is LoginSuccess) {
          if (state.userType == "ADMIN") {
            return context.go("/admin/home");
          } else if (state.userType == "DRIVER") {
            return context.go("/driver/home");
          }
          return context.go("/commuter/home");
        } else if (state is LoginConnectionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * .10,
                left: 20,
                child: const Image(
                  image: AssetImage('assets/bus.png'),
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .22,
                left: 30,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "Let's get you started!",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 170.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100.0),
                    // Email Field
                    TextField(
                      controller: _emailController,
                      enabled: _termsAccepted,
                      cursorColor: const Color(0xFF00A2FF),
                      onChanged: (text) {
                        if (_debounceEmail?.isActive ?? false)
                          _debounceEmail?.cancel();
                        _debounceEmail = Timer(debounceDurationEmail, () async {
                          String? validationError =
                              validateEmailOrPhoneNumber(text);
                          setState(() {
                            emailError = validationError;
                          });
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email or phone number',
                        labelStyle:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        prefixIcon: Icon(
                          Icons.email,
                          color: _termsAccepted
                              ? const Color(0xFF00A2FF)
                              : Colors.grey,
                        ),
                        iconColor: const Color(0xFF00A2FF),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                        ),
                        errorText: emailError,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      enabled: _termsAccepted,
                      cursorColor: const Color(0xFF00A2FF),
                      onChanged: (text) {
                        if (_debouncePassword?.isActive ?? false)
                          _debouncePassword?.cancel();
                        _debouncePassword =
                            Timer(debounceDurationPassword, () async {
                          String? validationError = validatePassword(text);
                          setState(() {
                            passwordError = validationError;
                          });
                        });
                      },
                      obscureText: !_isPasswordVisible,
                      cursorErrorColor: const Color(0xFF00A2FF),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            const TextStyle(fontSize: 13, color: Colors.black),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: _termsAccepted
                              ? const Color(0xFF00A2FF)
                              : Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: _termsAccepted
                                ? const Color(0xFF00A2FF)
                                : Colors.grey,
                          ),
                          onPressed: _termsAccepted
                              ? () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                }
                              : null,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                        ),
                        errorText: passwordError,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRememberMeChecked,
                              activeColor: const Color(0xFF00A2FF),
                              onChanged: _termsAccepted
                                  ? (bool? value) {
                                      setState(() {
                                        _isRememberMeChecked = value ?? false;
                                      });
                                    }
                                  : null,
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                        TextButton(
                          onPressed: _termsAccepted ? () {} : null,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: _termsAccepted ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    ElevatedButton(
                      onPressed: _termsAccepted
                          ? () {
                              String? isValidEmail = validateEmailOrPhoneNumber(
                                  _emailController.text);
                              if (isValidEmail != null) {
                                setState(() {
                                  emailError = isValidEmail;
                                });
                                return;
                              }
                              String? isValidPassword =
                                  validatePassword(_passwordController.text);
                              if (isValidPassword != null) {
                                setState(() {
                                  passwordError = isValidPassword;
                                });
                                return;
                              }
                              final newUser = LoginUserModel(
                                user_identifier: _emailController.text,
                                password: _passwordController.text,
                              );
                              _authBloc.add(LoginEvent(newUser));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _termsAccepted
                            ? const Color(0xFF00A2FF)
                            : Colors.grey[300],
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 140.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color:
                              _termsAccepted ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account yet?',
                            style: TextStyle(fontSize: 13)),
                        TextButton(
                          onPressed: _termsAccepted
                              ? () {
                                  context.go('/signup');
                                }
                              : null,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 13,
                              color: _termsAccepted
                                  ? const Color(0xFF00A2FF)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditionsDialog extends StatefulWidget {
  @override
  State<_TermsAndConditionsDialog> createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<_TermsAndConditionsDialog> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📄 Terms and Conditions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Container with Border and ScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'By agreeing to these Terms and Conditions, you acknowledge and accept the following:',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      _buildSection(
                        '1. Usage of Sakay',
                        'Sakay is a free public transportation companion app that provides real-time vehicle tracking, ETA notifications, and route optimization for commuters and drivers along the Lingayen-Dagupan route. The app is intended for UPang students, daily commuters, PWDs, and registered drivers.',
                      ),
                      _buildSection(
                        '2. Account & Access',
                        'Users are required to create an account using a valid email address and password. Drivers and commuters have separate access and features based on their account type.',
                      ),
                      _buildSection(
                        '3. Data Collection',
                        'By using Sakay, you consent to the collection and secure storage of your email address and password for account authentication and communication purposes. We do not sell or share your information with third parties.',
                      ),
                      _buildSection(
                        '4. Announcements & Communication',
                        'Admins may post important announcements which are visible to users through the app. These may include service updates, route adjustments, or general notices relevant to the Sakay system.',
                      ),
                      _buildSection(
                        '5. Service Availability',
                        'While we aim to provide real-time, accurate vehicle data, Sakay does not guarantee uninterrupted access or flawless performance. GPS or internet issues may affect real-time tracking at times.',
                      ),
                      _buildSection(
                        '6. Acceptable Use',
                        'Users must not attempt to disrupt the service, misuse data, or impersonate others. Abuse or suspicious activity may result in account restriction.',
                      ),
                      _buildSection(
                        '7. Changes to Terms',
                        'We may update these Terms and Conditions as the service evolves. Users will be notified of significant changes through the app.',
                      ),
                      _buildSection(
                        '8. Contact & Support',
                        'For questions, feedback, or issues, please reach out through our admin portal or the official Sakay website.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isAgreed,
                  activeColor: const Color(0xFF00A2FF),
                  onChanged: (bool? value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'By agreeing to these terms and conditions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAgreed 
                  ? () => Navigator.of(context).pop(true)
                  : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAgreed 
                    ? const Color(0xFF00A2FF) 
                    : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isAgreed ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
