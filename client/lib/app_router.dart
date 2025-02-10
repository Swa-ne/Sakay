import 'package:go_router/go_router.dart';
import 'package:sakay_app/presentation/screens/admin/admin_map.dart';
import 'package:sakay_app/presentation/screens/authentication/login_page.dart';
import 'package:sakay_app/presentation/screens/authentication/register_firstpage.dart';
import 'package:sakay_app/presentation/screens/authentication/register_page.dart';
import 'package:sakay_app/presentation/screens/commuter/home_page.dart';
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
      builder: (context, state) => const RegisterPage(),
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
