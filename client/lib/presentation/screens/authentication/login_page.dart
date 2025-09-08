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
  bool _acceptedTerms = false;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00A2FF),
                  Color(0xFFF3F3F3),
                ],
                stops: [0.4, 0.3],
              ),
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Logo
                      Positioned(
                        top: screenHeight * 0.05,
                        left: 0,
                        right: 0,
                        child: const Image(
                          image: AssetImage('assets/lugo.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),

                      // Title
                      Positioned(
                        top: screenHeight * 0.18,
                        left: 0,
                        right: 0,
                        child: const Column(
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Please, sign in to continue',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container Form
                      Positioned(
                        top: screenHeight * 0.28,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildEmailField(),
                              const SizedBox(height: 10),
                              _buildPasswordField(),
                              _buildForgotAndTerms(),
                              const SizedBox(height: 15),
                              _buildLoginButton(),
                              const SizedBox(height: 20),
                              const Divider(
                                color: Colors.grey,
                                height: 20,
                                thickness: 0.5,
                                indent: 80,
                                endIndent: 80,
                              ),
                              const SizedBox(height: 10),
                              _buildRegisterRow(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email or Phone Number',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _emailController,
          cursorColor: const Color(0xFF00A2FF),
          onChanged: (text) {
            if (_debounceEmail?.isActive ?? false) _debounceEmail?.cancel();
            _debounceEmail = Timer(debounceDurationEmail, () async {
              String? validationError = validateEmailOrPhoneNumber(text);
              setState(() {
                emailError = validationError;
              });
            });
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email, color: Color(0xFF00A2FF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00A2FF)),
            ),
            errorText: emailError,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          cursorColor: const Color(0xFF00A2FF),
          decoration: InputDecoration(
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00A2FF)),
            ),
            errorText: passwordError,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotAndTerms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Checkbox(
              value: _acceptedTerms,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
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
                  // open Terms & Conditions page
                },
                child: const Text(
                  'I agree to the Terms & Conditions',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        if (!_acceptedTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.white,
              content: Text(
                "You must accept the Terms & Conditions",
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
          return;
        }

        String? isValidEmail =
            validateEmailOrPhoneNumber(_emailController.text);
        if (isValidEmail != null) {
          setState(() {
            emailError = isValidEmail;
          });
          return;
        }
        String? isValidPassword = validatePassword(_passwordController.text);
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
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account yet?",
            style: TextStyle(fontSize: 13)),
        TextButton(
          onPressed: () {
            context.go('/signup');
          },
          child: const Text(
            'Register',
            style: TextStyle(fontSize: 13, color: Color(0xFF00A2FF)),
          ),
        ),
      ],
    );
  }
}
