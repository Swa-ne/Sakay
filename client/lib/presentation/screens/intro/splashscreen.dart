import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  @override
  void initState() {
    super.initState();
    _checkInternetAndAuthenticate();
  }

  Future<void> _checkInternetAndAuthenticate() async {
    Future.any([
      Future.delayed(const Duration(seconds: 3)),
      _authenticateUser(),
    ]).then((_) async {
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
        } else if (state is AuthFailure &&
            state.error == "No internet connection") {
          final List<ConnectivityResult> connectivityResult =
              await Connectivity().checkConnectivity();
          if (connectivityResult.contains(ConnectivityResult.none)) {
            if (mounted) {
              context.go('/no_internet_connection');
            }
            return;
          }
          final String user_type = await _tokenController.getUserType();
          if (user_type == "ADMIN") {
            context.go('/admin/home');
            return;
          } else if (user_type == "DRIVER") {
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
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/lugo.png',
              height: 150.0,
              color: isDarkMode ? Colors.white : null,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Loading...",
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
