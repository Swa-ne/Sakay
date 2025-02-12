import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/app_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/core/configs/theme/app_theme.dart';
import 'package:sakay_app/data/sources/authentication/auth_repo_impl.dart';
import 'package:sakay_app/data/sources/tracker/socket_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  String accessToken = "${dotenv.env['ACCESS_TOKEN']}";
  MapboxOptions.setAccessToken(accessToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TrackerBloc(SocketControllerImpl()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(AuthRepoImpl()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sakay',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            title: 'Sakay',
            routerConfig: appRouter,
          ),
        ),
      ),
    );
  }
}
