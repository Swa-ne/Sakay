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

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/driver.png',
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 185,
                left: 30,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage('assets/sakaylogo.png'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 220.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100.0),
                    // Email Field
                    TextField(
                      controller: _emailController,
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
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF00A2FF),
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
                    const SizedBox(height: 20.0),

                    // Password Field
                    TextField(
                      controller: _passwordController,
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
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF00A2FF),
                        ),
                        suffixIcon: const Icon(
                          Icons.visibility,
                          color: Color(0xFF00A2FF),
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                        ),
                        errorText: passwordError,
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isRememberMeChecked,
                              activeColor: const Color(0xFF00A2FF),
                              onChanged: (bool? value) {
                                setState(() {
                                  _isRememberMeChecked = value ?? false;
                                });
                              },
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    ElevatedButton(
                      onPressed: () {
                        String? isValidEmail =
                            validateEmailOrPhoneNumber(_emailController.text);
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A2FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 150.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account yet?'),
                        TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Color(0xFF00A2FF)),
                          ),
                        ),
                      ],
                    ),

                    // Google Sign-In Button
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/google_icon.png', height: 24.0),
                      label: const Text('Sign in with Google'),
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
