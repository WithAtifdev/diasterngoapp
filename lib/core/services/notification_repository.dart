import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  final String baseUrl;
  final Future<String?> Function()? authTokenProvider;

  NotificationRepository({
     this.baseUrl = 'https://us-central1-diasterngoapp-4f51a.cloudfunctions.net',
    this.authTokenProvider,
  });

  Future<bool> sendDisasterTopicMessage({
    required String topic,
    required String title,
    required String body,
    required String severity,
    String? alertId,
    String? description,
    String? source,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    final uri = Uri.parse('$baseUrl/sendDisasterTopicNotification');

    try {
      final authToken = await authTokenProvider?.call() ??
          await FirebaseAuth.instance.currentUser?.getIdToken();

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'topic': topic,
          'title': title,
          'body': body,
          'description': description ?? body,
          'severity': severity,
          'alertId': alertId,
          'source': source,
          'type': type,
          'data': data ?? <String, dynamic>{},
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
