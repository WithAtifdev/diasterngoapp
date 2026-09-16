import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:diaster_ngo_app/features/alerts/view/alert_details_screen.dart';

class NotificationPayload {
  final String title;
  final String body;
  final String severity;
  final Map<String, dynamic>? data;

  const NotificationPayload({
    required this.title,
    required this.body,
    required this.severity,
    this.data,
  });

  static NotificationPayload fromRemoteMessage(RemoteMessage message) {
    final data = <String, dynamic>{
      ...message.data,
      if (message.notification?.title != null)
        'title': message.notification!.title,
      if (message.notification?.body != null)
        'body': message.notification!.body,
      'severity': message.data['severity']?.toString() ?? 'info',
      'source': message.data['source']?.toString() ?? 'firebase',
      'type': message.data['type']?.toString() ?? 'disaster_alert',
      'alertId': message.data['alertId']?.toString() ?? message.data['id']?.toString() ?? '',
    };

    return NotificationPayload(
      title: message.notification?.title ?? data['title']?.toString() ?? 'Disaster Update',
      body: message.notification?.body ?? data['body']?.toString() ?? 'New emergency update available.',
      severity: data['severity']?.toString() ?? 'info',
      data: data,
    );
  }
}

class NotificationService {
  NotificationService();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'disaster_alerts',
    'Disaster Alerts',
    description: 'Emergency disaster and risk alerts',
    importance: Importance.max,
    enableVibration: true,
  );

  static NotificationPayload makeNotificationPayload({
    required String title,
    required String body,
    required String severity,
    Map<String, dynamic>? data,
  }) {
    final safeData = <String, dynamic>{
      ...?data,
      'severity': severity,
      'title': title,
      'body': body,
      'type': data?['type']?.toString() ?? 'disaster_alert',
    };

    return NotificationPayload(
      title: title,
      body: body,
      severity: severity,
      data: safeData,
    );
  }

  Future<void> initialize({GlobalKey<NavigatorState>? appNavigatorKey}) async {
    if (_initialized) return;

    if (appNavigatorKey != null) {
      navigatorKey = appNavigatorKey;
    }

    if (!kIsWeb) {
      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _openAlertFromPayload(response.payload);
        },
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final payload = NotificationPayload.fromRemoteMessage(message);
        showLocalNotification(payload);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final payload = NotificationPayload.fromRemoteMessage(message);
        _openAlertFromPayload(jsonEncode(payload.data ?? {}));
      });

      FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
        await _refreshToken(token);
      });

      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        final token = await FirebaseMessaging.instance.getToken();
        await _registerToken(token);
      }

      await FirebaseMessaging.instance.subscribeToTopic('all_disaster_alerts');
    }

    _initialized = true;
  }

  Future<void> _registerToken(String? token) async {
    if (token == null || token.isEmpty) return;

    // Local FCM registration is implemented through the Firebase plugin API.
    // Any server-side token persistence needs a real Firebase Function/HTTP endpoint;
    // this repository does not contain that endpoint.
  }

  Future<void> _refreshToken(String token) async {
    await _registerToken(token);
  }

  Future<void> showLocalNotification(NotificationPayload payload) async {
    final androidPlatformDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: payload.title,
      styleInformation: BigTextStyleInformation(
        payload.body,
        htmlFormatContent: true,
      ),
    );

    final notificationDetails = NotificationDetails(
      android: androidPlatformDetails,
      iOS: const DarwinNotificationDetails(),
    );

    final payloadMap = <String, dynamic>{
      if (payload.data != null) ...payload.data!,
      'title': payload.title,
      'body': payload.body,
      'severity': payload.severity,
      'type': payload.data?['type']?.toString() ?? 'disaster_alert',
    };

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: payload.title,
      body: payload.body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(payloadMap),
    );
  }

  Future<void> sendTopicMessage({
    required String topic,
    required String title,
    required String body,
    required String severity,
  }) async {
    final payload = makeNotificationPayload(
      title: title,
      body: body,
      severity: severity,
      data: {
        'topic': topic,
        'type': 'disaster_alert',
      },
    );

    await showLocalNotification(payload);
  }

  void _openAlertFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return;

      final alertId = decoded['alertId']?.toString() ??
          decoded['id']?.toString() ??
          decoded['alert_id']?.toString() ??
          '';

      final title = decoded['title']?.toString() ?? 'Alert Details';
      final description = decoded['body']?.toString() ??
          decoded['description']?.toString() ??
          '';
      final severity = decoded['severity']?.toString() ?? 'info';
      final source = decoded['source']?.toString() ?? decoded['type']?.toString() ?? 'firebase';

      final context = navigatorKey.currentContext;
      if (context == null) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AlertDetailsScreen(
            alertId: alertId,
            title: title,
            description: description,
            severity: severity,
            source: source,
            createdAt: null,
          ),
        ),
      );
    } catch (_) {
      return;
    }
  }
}

