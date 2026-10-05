
import 'package:diaster_ngo_app/core/services/notification_service.dart';
import 'package:diaster_ngo_app/features/alerts/services/alert_service.dart';
import 'package:diaster_ngo_app/features/alerts/view_model/alerts_view_model.dart';
import 'package:diaster_ngo_app/features/auth/services/auth_service.dart';
import 'package:diaster_ngo_app/features/auth/view/Splasch_screen.dart';
import 'package:diaster_ngo_app/features/auth/view_model/auth_view_model.dart';
import 'package:diaster_ngo_app/features/home/services/earthquake_service.dart';
import 'package:diaster_ngo_app/features/home/services/flood_service.dart';
import 'package:diaster_ngo_app/features/home/services/location_service.dart';
import 'package:diaster_ngo_app/features/home/services/weather_service.dart';
import 'package:diaster_ngo_app/features/home/view_model/home_view_model.dart';
import 'package:diaster_ngo_app/features/ngos/services/ngo_service.dart';
import 'package:diaster_ngo_app/features/ngos/view_model/ngo_register_view_model.dart';
import 'package:diaster_ngo_app/features/ngos/view_model/ngo_view_model.dart';
import 'package:diaster_ngo_app/features/profile/services/profile_service.dart';
import 'package:diaster_ngo_app/features/profile/view_model/profile_view_model.dart';
import 'package:diaster_ngo_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _bgHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final payload = NotificationPayload.fromRemoteMessage(message);
  final service = NotificationService();

  if (!kIsWeb) {
    await service.showLocalNotification(payload);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_bgHandler);

    final notificationService = NotificationService();
    await notificationService.initialize(
      appNavigatorKey: appNavigatorKey,
    );
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// =================================
        /// SERVICES
        /// =================================
        Provider(
          create: (_) => AuthService(),
        ),

        Provider(
          create: (_) => LocationService(),
        ),

        Provider(
          create: (_) => WeatherService(),
        ),

        Provider(
          create: (_) => EarthquakeService(),
        ),

        Provider(
          create: (_) => FloodService(),
        ),

        Provider(
          create: (_) => AlertService(),
        ),

        Provider(
          create: (_) => NGOService(),
        ),
        Provider(
          create: (_) => ProfileService(),
        ),


        ChangeNotifierProvider(
          create:
              (ctx) => AuthViewModel(
            ctx.read<AuthService>(),
          ),
        ),

        ChangeNotifierProvider(
          create:
              (ctx) => HomeViewModel(
            ctx.read<WeatherService>(),
            ctx.read<
                EarthquakeService>(),
            ctx.read<FloodService>(),
            ctx.read<LocationService>(),
          ),
        ),

        ChangeNotifierProvider(
          create:
              (ctx) => AlertsViewModel(
            ctx.read<AlertService>(),
          ),
        ),

        ChangeNotifierProvider(
          create:
              (ctx) => NGOViewModel(
            ctx.read<NGOService>(),
          ),
        ),

        ChangeNotifierProvider(
          create:
              (ctx) =>
              NGORegisterViewModel(
                service:
                ctx.read<NGOService>(),
              ),
        ),

        ChangeNotifierProxyProvider<
            AuthViewModel,ProfileViewModel>(
          create:
              (ctx) => ProfileViewModel(
            service: ctx.read<ProfileService>(),
          ),

          update: (context, authVm, previous) {
            if (previous == null) {
              return ProfileViewModel(
                service: context.read<ProfileService>(),
              );
            }
            previous.updateAuth(authVm);
            return previous;
          },
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner:
        false,
        navigatorKey: appNavigatorKey,
        title:
        'Disaster & NGO Community App',
        theme: AppTheme.darkTheme,
        home: const Splaschscreen(),
      ),
    );
  }
}