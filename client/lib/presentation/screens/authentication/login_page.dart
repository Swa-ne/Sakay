import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/register_firstpage.dart';
import 'package:sakay_app/presentation/screens/commuter/home_page.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 220.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100.0),
                  // Email Field
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color(0xFF00A2FF),
                      ),
                      iconColor: Color(0xFF00A2FF),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xFF00A2FF),
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: Color(0xFF00A2FF),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                      ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()), // HomePage() to Map()
                      );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage1()),
                          );
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
    );
  }
}
