import 'package:go_router/go_router.dart';
import 'package:sakay_app/data/models/sign_up.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/authentication/email_code.dart';
import 'package:sakay_app/presentation/screens/authentication/login_page.dart';
import 'package:sakay_app/presentation/screens/authentication/phone_verification.dart';
import 'package:sakay_app/presentation/screens/authentication/register_firstpage.dart';
import 'package:sakay_app/presentation/screens/authentication/register_page.dart';
import 'package:sakay_app/presentation/screens/authentication/usertype.dart';
import 'package:sakay_app/presentation/screens/commuters/home.dart';
import 'package:sakay_app/presentation/screens/driver/driver_location.dart';
import 'package:sakay_app/presentation/screens/driver/driver_manage_vehicle.dart';
import 'package:sakay_app/presentation/screens/intro/guide_screen.dart';
import 'package:sakay_app/presentation/screens/intro/splashscreen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const GuideScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage1(),
    ),
    GoRoute(
      path: '/signup2',
      builder: (context, state) {
        final signupData = state.extra as SignUpUserModel;
        return RegisterPage(signupData: signupData);
      },
    ),
    GoRoute(
      path: '/user_type',
      builder: (context, state) {
        final signupData = state.extra as SignUpUserModel;
        return UserTypePage(signupData: signupData);
      },
    ),
    GoRoute(
      path: '/phone_verification',
      builder: (context, state) {
        return PhoneVerificationPage();
      },
    ),
    GoRoute(
      path: '/email_verification',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final email = extras['email_address'] as String;
        final token = extras['token'] as String;

        return EmailVerificationCodePage(email_address: email, token: token);
      },
    ),
    // COMMUTER paths
    GoRoute(
      path: '/commuter/home',
      builder: (context, state) => const HomePage(),
    ),
    // DRIVER paths
    GoRoute(
      path: '/driver/home',
      builder: (context, state) => const AdminMap(),
    ),
    // ADMIN paths
    GoRoute(
      path: '/admin/home',
      builder: (context, state) => const AdminMap(),
    ),
  ],
);
