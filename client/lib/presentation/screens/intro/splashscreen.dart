import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.any([
      Future.delayed(const Duration(seconds: 3)), // Timeout
      _authenticateUser(),
    ]).then((_) {
      if (mounted) {
        final state = context.read<AuthBloc>().state;
        if (state is AuthSuccess) {
          if (state.userType == "ADMIN") {
            context.go('/admin/home');
            return;
          } else if (state.userType == "DRIVER") {
            context.go('/driver/home');
            return;
          }
          context.go('/commuter/home');
        } else {
          context.go('/onboarding');
        }
      }
    });
  }

  Future<void> _authenticateUser() async {
    context.read<AuthBloc>().add(AuthenticateTokenEvent());
    await Future.delayed(
        const Duration(seconds: 3)); // Ensure splash time is at least 3s
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sakaylogo.png',
              height: 400.0,
            ),
            const SizedBox(height: 20.0),
            const CircularProgressIndicator(color: Color(0xFF00A2FF)),
          ],
        ),
      ),
    );
  }
}
