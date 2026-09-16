

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaster_ngo_app/core/services/notification_repository.dart';
import 'package:diaster_ngo_app/core/services/notification_service.dart';
import 'package:diaster_ngo_app/features/alerts/model/alert_model.dart';
import 'package:diaster_ngo_app/features/home/services/earthquake_service.dart';
import 'package:diaster_ngo_app/features/home/services/location_service.dart';
import 'package:diaster_ngo_app/features/home/services/weather_service.dart';

class AlertService {
  final FirebaseFirestore  _db       = FirebaseFirestore.instance;
  final EarthquakeService  _quakeSvc = EarthquakeService();
  final WeatherService     _wxSvc    = WeatherService();
  final LocationService    _locSvc   = LocationService();
  final NotificationService _notificationService = NotificationService();
  final NotificationRepository _notificationRepository = NotificationRepository();

  Stream<List<AlertModel>> officialAlertStream() {
    return _db
        .collection('alerts')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snap) => snap.docs
        .map((d) => AlertModel.fromFirestore(d.data(), d.id))
        .toList());
  }

  Future<List<AlertModel>> fetchLiveAlerts() async {
    final alerts = <AlertModel>[];

    try {
      final loc = await _locSvc.getCurrentLocation();

      // Earthquake alerts
      final quakes = await _quakeSvc.fetchNearby(
        lat: loc.lat,
        lon: loc.lon,
        radiusKm: 1000,
      );
      for (final q in quakes) {
        if (q.magnitude >= 3.5) {
          alerts.add(AlertModel.fromEarthquake(q));
        }
      }

      // Weather alerts
      final weather = await _wxSvc.fetch(lat: loc.lat, lon: loc.lon);
      if (weather.precipitationMm > 20 || weather.windSpeedKph > 40) {
        alerts.add(AlertModel.fromWeather(weather, loc.city));
      }
    } catch (e) {
      if (alerts.isEmpty) {
        alerts.add(
          AlertModel(
            id: 'system_error',
            title: 'Live alert refresh failed',
            description: e.toString(),
            severity: AlertSeverity.info,
            source: AlertSource.firebase,
            createdAt: DateTime.now(),
          ),
        );
      }
    }

    if (alerts.isNotEmpty) {
      final first = alerts.first;
      final payload = NotificationService.makeNotificationPayload(
        title: first.title,
        body: first.description,
        severity: first.severity.name,
        data: {
          'type': first.source.name,
          'source': first.sourceLabel,
        },
      );

      try {
        await _notificationService.showLocalNotification(payload);
      } catch (_) {
        // Notification channel or payload creation should never kill the UI.
      }

      try {
        await _notificationRepository.sendDisasterTopicMessage(
          topic: 'all_disaster_alerts',
          title: payload.title,
          body: payload.body,
          description: first.description,
          severity: payload.severity,
          alertId: first.id,
          source: first.sourceLabel,
          type: first.source.name,
          data: {
            'alertId': first.id,
            'description': first.description,
            'source': first.sourceLabel,
            'type': first.source.name,
            'createdAt': first.createdAt.toIso8601String(),
          },
        );
      } catch (_) {
        // The app should still render the alert list even if remote messaging fails.
      }
    }

    alerts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return alerts;
  }

  Future<void> addAlert(Map<String, dynamic> data) =>
      _db.collection('alerts').add(data);
}