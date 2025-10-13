import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakay_app/bloc/bus/bus_bloc.dart';
import 'package:sakay_app/bloc/chat/chat_bloc.dart';
import 'package:sakay_app/bloc/announcement/announcement_bloc.dart';
import 'package:sakay_app/bloc/report/report_bloc.dart';
import 'package:sakay_app/common/widgets/sos_alert_dialog.dart';
import 'package:sakay_app/core/configs/theme/theme_cubit.dart';
import 'package:sakay_app/data/sources/realtime/chat_repo_impl.dart';
import 'package:sakay_app/data/sources/realtime/announcement_repo_impl.dart';
import 'package:sakay_app/data/sources/realtime/report_repo_impl.dart';
import 'package:sakay_app/data/sources/realtime/socket_controller.dart';
import 'package:sakay_app/data/sources/tracker/bus_repo_impl.dart';
import 'package:sakay_app/presentation/app_router.dart';
import 'package:sakay_app/bloc/authentication/auth_bloc.dart';
import 'package:sakay_app/bloc/tracker/tracker_bloc.dart';
import 'package:sakay_app/core/configs/theme/app_theme.dart';
import 'package:sakay_app/data/sources/authentication/auth_repo_impl.dart';
import 'package:sakay_app/data/sources/tracker/socket_controller.dart';

// NEW:
import 'core/sos_notifier.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  String accessToken = "${dotenv.env['ACCESS_TOKEN']}";
  MapboxOptions.setAccessToken(accessToken);

  final themeCubit = ThemeCubit();
  await themeCubit.loadTheme();

  runApp(MyApp(themeCubit: themeCubit));
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;
  const MyApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<String>(
        stream: SosNotifier().stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final currentContext = navigatorKey.currentContext;
              if (currentContext != null) {
                showDialog(
                  context: currentContext,
                  builder: (_) => SosAlertDialog(commuterName: snapshot.data!),
                );
              }
            });
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => TrackerBloc(TrackingSocketControllerImpl()),
              ),
              BlocProvider(
                create: (context) => AuthBloc(AuthRepoImpl()),
              ),
              BlocProvider(
                create: (context) => ChatBloc(
                  ChatRepoImpl(),
                  RealtimeSocketControllerImpl(),
                ),
              ),
              BlocProvider(
                create: (context) => AnnouncementBloc(
                  AnnouncementRepoImpl(),
                  RealtimeSocketControllerImpl(),
                ),
              ),
              BlocProvider(
                create: (context) => ReportBloc(
                  ReportRepoImpl(),
                  RealtimeSocketControllerImpl(),
                ),
              ),
              BlocProvider(
                create: (context) => BusBloc(BusRepoImpl()),
              ),
              BlocProvider.value(value: themeCubit),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Sakay',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    title: 'Sakay',
                    routerConfig: appRouter,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
