import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../home/model/earthquake_model.dart';
import '../../home/model/flood_model.dart';
import '../../home/model/weather_model.dart';

enum AlertSeverity { extreme, high, medium, info }
enum AlertSource   { firebase, usgs, weather, gdacs, flood }

class AlertModel {
  final String        id;
  final String        title;
  final String        description;
  final AlertSeverity severity;
  final AlertSource   source;
  final DateTime      createdAt;
  final double?       latitude;
  final double?       longitude;
  final String?       sourceUrl;

  const AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.source,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.sourceUrl,
  });

  Color get color {
    switch (severity) {
      case AlertSeverity.extreme: return AppColors.extreme;
      case AlertSeverity.high:    return AppColors.high;
      case AlertSeverity.medium:  return AppColors.medium;
      case AlertSeverity.info:    return AppColors.primaryBlue;
    }
  }

  IconData get icon {
    switch (source) {
      case AlertSource.usgs:     return Icons.vibration;
      case AlertSource.weather:  return Icons.cloud;
      case AlertSource.gdacs:    return Icons.public;
      case AlertSource.flood:    return Icons.water;
      case AlertSource.firebase: return Icons.warning;
    }
  }

  String get timeLabel => TimeFormatter.timeAgo(createdAt);

  String get sourceLabel {
    switch (source) {
      case AlertSource.usgs:     return 'USGS';
      case AlertSource.weather:  return 'Weather';
      case AlertSource.gdacs:    return 'GDACS';
      case AlertSource.flood:    return 'Flood';
      case AlertSource.firebase: return 'Official';
    }
  }

  factory AlertModel.fromFirestore(Map<String, dynamic> data, String id) =>
      AlertModel(
        id:          id,
        title:       data['title'] ?? '',
        description: data['description'] ?? '',
        severity:    AlertSeverity.values.firstWhere(
                (s) => s.name == (data['severity'] ?? 'info'),
            orElse: () => AlertSeverity.info),
        source:      AlertSource.firebase,
        createdAt:   (data['createdAt'] is int)
            ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
            : DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
        latitude:    (data['latitude'] as num?)?.toDouble(),
        longitude:   (data['longitude'] as num?)?.toDouble(),
        sourceUrl:   data['sourceUrl'],
      );

  // Factory from USGS earthquake
  factory AlertModel.fromEarthquake(EarthquakeModel quake) => AlertModel(
    id:          'usgs_${quake.id}',
    title:       'Earthquake M${quake.magnitude.toStringAsFixed(1)}',
    description: quake.place,
    severity:    quake.magnitude >= 5.0 ? AlertSeverity.high : AlertSeverity.medium,
    source:      AlertSource.usgs,
    createdAt:   quake.occurredAt,
    latitude:    quake.latitude,
    longitude:   quake.longitude,
    sourceUrl:   quake.url,
  );

  // Factory from weather
  factory AlertModel.fromWeather(WeatherModel weather, String location) {
    final isExtreme = weather.precipitationMm > 50 || weather.windSpeedKph > 80;
    return AlertModel(
      id:          'weather_${DateTime.now().millisecondsSinceEpoch}',
      title:       isExtreme ? 'Extreme Weather Warning' : 'Heavy Rain Warning',
      description: '${weather.condition} — ${weather.precipitationMm.toStringAsFixed(1)} mm rainfall, '
          '${weather.windSpeedKph.toStringAsFixed(0)} km/h wind in $location',
      severity:    isExtreme ? AlertSeverity.high : AlertSeverity.medium,
      source:      AlertSource.weather,
      createdAt:   DateTime.now(),
    );
  }

  factory AlertModel.fromGdacs(
      Map<String, dynamic> feature)
  {
    final properties =
        feature['properties'] as Map<String, dynamic>? ?? {};
    final geometry = feature['geometry'] as Map<String, dynamic>?;
    final coordinates = geometry?['coordinates'] as List?;
    final alertLevel =
    (properties['alertlevel'] ?? 'Green').toString().toLowerCase();
    final AlertSeverity severity;
    switch (alertLevel) {
      case 'red':
        severity = AlertSeverity.extreme;
        break;
      case 'orange':
        severity = AlertSeverity.high;
        break;
      case 'green':
        severity = AlertSeverity.info;
        break;
      default:
        severity = AlertSeverity.medium;
    }
    final eventType =
    (properties['eventtype'] ?? 'Disaster').toString();
    final eventName = (properties['name'] ?? 'Disaster Alert').toString();
    final createdAtString = properties['fromdate']?.toString();
    final createdAt =
        DateTime.tryParse(createdAtString ?? '') ??
            DateTime.now();
    return AlertModel(
      id: 'gdacs_${properties['eventid'] ?? DateTime.now().millisecondsSinceEpoch}',
      title: eventName,
      description:
      '$eventType disaster detected by GDACS. '
          'Alert level: ${alertLevel.toUpperCase()}',
      severity: severity,
      source: AlertSource.gdacs,
      createdAt: createdAt,
      latitude: coordinates != null && coordinates.length > 1
          ? (coordinates[1] as num).toDouble()
          : null,
      longitude: coordinates != null && coordinates.isNotEmpty
          ? (coordinates[0] as num).toDouble()
          : null,
      sourceUrl: properties['url']?.toString(),
    );
  }

  factory AlertModel.fromFlood(
      FloodModel flood,
      String location,
      )
  {
    final isSevere = flood.riverDischarge > 500;
    final isHigh = flood.riverDischarge > 200;
    return AlertModel(
      id: 'flood_${DateTime.now().millisecondsSinceEpoch}',
      title: isSevere
          ? 'Severe Flood Warning'
          : isHigh
          ? 'Flood Warning'
          : 'Flood Alert',
      description:
      'River discharge is '
          '${flood.riverDischarge.toStringAsFixed(1)} m³/s '
          'in $location.',
      severity: isSevere
          ? AlertSeverity.extreme
          : isHigh
          ? AlertSeverity.high
          : AlertSeverity.medium,
      source: AlertSource.flood,
      createdAt: flood.fetchedAt,
    );
  }
}