
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaster_ngo_app/core/services/notification_repository.dart';
import 'package:diaster_ngo_app/core/services/notification_service.dart';
import 'package:diaster_ngo_app/features/alerts/model/alert_model.dart';
import 'package:diaster_ngo_app/features/alerts/services/gdacs_service.dart';
import 'package:diaster_ngo_app/features/home/services/earthquake_service.dart';
import 'package:diaster_ngo_app/features/home/services/flood_service.dart';
import 'package:diaster_ngo_app/features/home/services/location_service.dart';
import 'package:diaster_ngo_app/features/home/services/weather_service.dart';

class AlertService {
  // Firebase
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Live API services
  final EarthquakeService _quakeSvc = EarthquakeService();
  final WeatherService _wxSvc = WeatherService();
  final FloodService _floodSvc = FloodService();
  final GdacsService _gdacsSvc = GdacsService();
  final LocationService _locSvc = LocationService();

  // Notifications
  final NotificationService _notificationService =
  NotificationService();
  final NotificationRepository _notificationRepository =
  NotificationRepository();
  // ------------------------------------------------------------
  // FIREBASE OFFICIAL ALERTS
  // ------------------------------------------------------------
  Stream<List<AlertModel>> officialAlertStream() {
    return _db
        .collection('alerts')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map(
            (d) => AlertModel.fromFirestore(
          d.data(),
          d.id,
        ),
      )
          .toList(),
    );
  }

  // ------------------------------------------------------------
  // LIVE ALERTS
  // ------------------------------------------------------------

  Future<List<AlertModel>> fetchLiveAlerts() async {
    final alerts = <AlertModel>[];
    try {
      // ----------------------------------------------------------
      // LOCATION
      // ----------------------------------------------------------
      final loc = await _locSvc.getCurrentLocation();
      // ----------------------------------------------------------
      // EARTHQUAKE ALERTS - USGS
      // ----------------------------------------------------------
      final quakes = await _quakeSvc.fetchNearby(
        lat: loc.lat,
        lon: loc.lon,
        radiusKm: 250,
      );
      for (final q in quakes) {
        if (q.magnitude >= 3.5) {
          alerts.add(
            AlertModel.fromEarthquake(q),
          );
        }
      }
      // ----------------------------------------------------------
      // WEATHER ALERTS - OPEN-METEO
      // ----------------------------------------------------------
      final weather = await _wxSvc.fetch(
        lat: loc.lat,
        lon: loc.lon,
      );
      if (weather.precipitationMm > 20 ||
          weather.windSpeedKph > 40) {
        alerts.add(
          AlertModel.fromWeather(
            weather,
            loc.city,
          ),
        );
      }
      // ----------------------------------------------------------
      // FLOOD ALERTS - OPEN-METEO
      // ----------------------------------------------------------
      final flood = await _floodSvc.fetch(
        lat: loc.lat,
        lon: loc.lon,
      );
      if (flood.riskLabel != 'NORMAL' &&
          flood.riskLabel != 'UNKNOWN') {
        alerts.add(
          AlertModel.fromFlood(
            flood,
            loc.city,
          ),
        );
      }
      // ----------------------------------------------------------
      // GDACS ALERTS
      // ----------------------------------------------------------
      final gdacsAlerts = await _gdacsSvc.fetchAlerts();
      alerts.addAll(gdacsAlerts);
    } catch (e) {
      // ----------------------------------------------------------
      // ERROR
      // ----------------------------------------------------------
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
    // ------------------------------------------------------------
    // NOTIFICATIONS
    // ------------------------------------------------------------
    if (alerts.isNotEmpty) {
      final first = alerts.first;
      final payload =
      NotificationService.makeNotificationPayload(
        title: first.title,
        body: first.description,
        severity: first.severity.name,
        data: {
          'type': first.source.name,
          'source': first.sourceLabel,
        },
      );
      // ----------------------------------------------------------
      // LOCAL NOTIFICATION
      // ----------------------------------------------------------
      try {
        await _notificationService.showLocalNotification(
          payload,
        );
      } catch (_) {
        // Notification failure should not stop the app.
      }
      // ----------------------------------------------------------
      // FIREBASE CLOUD MESSAGE / TOPIC
      // ----------------------------------------------------------
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
            'createdAt':
            first.createdAt.toIso8601String(),
          },
        );
      } catch (_) {}
    }
    // ------------------------------------------------------------
    // SORT BY NEWEST
    // ------------------------------------------------------------
    alerts.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return alerts;
  }
  // ------------------------------------------------------------
  // ADD OFFICIAL FIREBASE ALERT
  // ------------------------------------------------------------
  Future<void> addAlert(
      Map<String, dynamic> data,
      ) =>
      _db.collection('alerts').add(data);
}