import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:sakay_app/data/sources/authentication/token_controller_impl.dart';

class NoInternetConnectionPage extends StatefulWidget {
  const NoInternetConnectionPage({super.key});

  @override
  State<NoInternetConnectionPage> createState() =>
      _NoInternetConnectionPageState();
}

class _NoInternetConnectionPageState extends State<NoInternetConnectionPage> {
  final TokenControllerImpl _tokenController = TokenControllerImpl();
  bool _isChecking = false;

  late String user_type;

  @override
  void initState() {
    super.initState();

    _initializeUserType();
  }

  Future<void> _initializeUserType() async {
    user_type = await _tokenController.getUserType();
  }

  Future<void> _retryConnection() async {
    setState(() {
      _isChecking = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    await Future.delayed(const Duration(seconds: 2));

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      if (mounted) {
        if (user_type == "ADMIN") {
          context.go('/admin/home');
          return;
        } else if (user_type == "DRIVER") {
          context.go('/driver/home');
          return;
        } else if (user_type == "COMMUTER") {
          context.go('/commuter/home');
          return;
        }
        context.go('/login');
      }
    } else {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isChecking ? null : _retryConnection,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _isChecking
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Retry', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
