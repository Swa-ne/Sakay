import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';

class EmailVerificationCodePage extends StatefulWidget {
  final String email_address;
  final String token;
  final bool isEmailVerification;

  const EmailVerificationCodePage({
    super.key,
    required this.email_address,
    required this.token,
    this.isEmailVerification = true,
  });

  @override
  State<EmailVerificationCodePage> createState() =>
      _EmailVerificationCodePageState();
}

class _EmailVerificationCodePageState extends State<EmailVerificationCodePage> {
  late AuthBloc _authBloc;

  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  Timer? _timer;
  int _countdown = 60;
  bool _isResendButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    startTimer();
  }

  void startTimer() {
    setState(() => _isResendButtonDisabled = true);
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _isResendButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResendEmailCodeSuccess) {
          if (state.isSuccess) {
            startTimer();
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet connection'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is VerifyEmailSuccess) {
          if (widget.isEmailVerification) {
            context.go("/commuter/home");
            return;
          }
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ChangeForgottenPassword(
          //       token: state.token,
          //     ),
          //   ),
          // );
        } else if (state is VerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 130.0),
                Center(
                  child: Image.asset(
                    'assets/sakay_logo.png',
                    height: 100.0,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Email Verification",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Enter the 6-digit code sent to your email",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 60.0,
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: UnderlineInputBorder(),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF00A2FF), width: 2.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String enteredCode = _controllers
                            .map((controller) => controller.text)
                            .join();
                        if (enteredCode.length == 6) {
                          _authBloc.add(
                            VerifyEmailEvent(widget.token, enteredCode),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please enter the full 6-digit code'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A2FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 140.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //   },
                          //   child: const Text(
                          //     "Edit Phone Number",
                          //     style: TextStyle(
                          //       fontSize: 14.0,
                          //       color: Colors.grey,
                          //     ),
                          //   ),
                          // ),
                          TextButton(
                            onPressed: _isResendButtonDisabled
                                ? null
                                : () {
                                    _authBloc.add(
                                        ResendEmailCodeEvent(widget.token));
                                  },
                            child: const Text(
                              "Resend Code",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF00A2FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
