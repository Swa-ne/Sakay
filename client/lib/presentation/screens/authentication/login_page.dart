import 'package:flutter/material.dart';
import 'package:sakay_app/presentation/screens/authentication/register_firstpage.dart';
import 'package:sakay_app/presentation/screens/commuters/home.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 250, 
              child: Stack(
                children: [
                  Image.asset(
                    'assets/driver.png',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const Positioned(
                    bottom: -40,
                    left: 20,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage('assets/sakaylogo.png'),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF00A2FF)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF00A2FF)),
                        suffixIcon: Icon(Icons.visibility, color: Color(0xFF00A2FF)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF00A2FF), width: 2.0),
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
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A2FF),
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 145.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      ),
                      child: const Text('Login', style: TextStyle(fontSize: 15.0, color: Colors.white)),
                    ),
                    const SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account yet?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpPage1()),
                            );
                          },
                          child: const Text('Register', style: TextStyle(color: Color(0xFF00A2FF))),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15.0),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Image.asset('assets/google_icon.png', height: 24.0),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

