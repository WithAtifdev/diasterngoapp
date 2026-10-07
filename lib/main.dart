
import 'package:diaster_ngo_app/app/app_providers.dart';
import 'package:diaster_ngo_app/core/services/notification_service.dart';
import 'package:diaster_ngo_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/routers/routes.dart';
import 'core/utils/routers/routes_name.dart';

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
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: appNavigatorKey,
        title: 'Disaster & NGO Community App',
        theme: AppTheme.darkTheme,
        initialRoute: RoutesName.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}