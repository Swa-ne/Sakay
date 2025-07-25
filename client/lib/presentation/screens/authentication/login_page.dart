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
                    const SizedBox(height: 10.0),

                    // Password Field
                    TextField(
                      controller: _passwordController,
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
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF00A2FF),
                        ),
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
                        errorText: passwordError,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
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
                        padding: EdgeInsets.symmetric(
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
                          color: Colors.white,
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
                          onPressed: () {
                            context.go('/signup');
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(
                                  0xFF00A2FF,
                                )),
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