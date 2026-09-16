
import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import 'package:diaster_ngo_app/features/home/model/weather_model.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum RiskLevel { extreme, high, medium, low }

class RiskResult {
  final RiskLevel level;
  final String label;
  final String emoji;
  final Color color;
  final String headline;
  final String recommendation;
  final List<String> activeThreatTypes;

  const RiskResult({
    required this.level,
    required this.label,
    required this.emoji,
    required this.color,
    required this.headline,
    required this.recommendation,
    required this.activeThreatTypes,
  });
}

class RiskCalculator {
  RiskCalculator._();

  static RiskResult calculate({
    required WeatherModel weather,
    required List<EarthquakeModel> nearbyQuakes,
    required FloodModel flood,
  }) {
    final threats = <String>[];
    int score = 0;

    // --- Earthquake risk ---
    final strongQuakes = nearbyQuakes.where((q) => q.magnitude >= 5.0).toList();
    final moderateQuakes = nearbyQuakes.where((q) => q.magnitude >= 3.5).toList();
    if (strongQuakes.isNotEmpty) {
      score += 40;
      threats.add('Earthquake M${strongQuakes.first.magnitude.toStringAsFixed(1)}+');
    } else if (moderateQuakes.isNotEmpty) {
      score += 20;
      threats.add('Seismic Activity');
    }

    // --- Flood risk ---
    if (flood.riverDischarge > 500) {
      score += 35;
      threats.add('Severe Flooding');
    } else if (flood.riverDischarge > 200) {
      score += 20;
      threats.add('Flood Warning');
    }

    // --- Weather risk ---
    if (weather.precipitationMm > 50 || weather.windSpeedKph > 80) {
      score += 30;
      threats.add('Extreme Weather');
    } else if (weather.precipitationMm > 20 || weather.windSpeedKph > 50) {
      score += 15;
      threats.add('Heavy Rain');
    }

    // --- Temperature extremes ---
    if (weather.temperatureCelsius > 45 || weather.temperatureCelsius < -10) {
      score += 15;
      threats.add('Temperature Extreme');
    }

    // --- Determine final level ---
    if (score >= 50) {
      return RiskResult(
        level: RiskLevel.extreme,
        label: 'EXTREME',
        emoji: '🔴',
        color: AppColors.extreme,
        headline: 'Extreme disaster risk detected',
        recommendation:
        'EVACUATE immediately if authorities advise. Move to high ground. '
            'Call emergency services. Do not use elevators.',
        activeThreatTypes: threats,
      );
    } else if (score >= 30) {
      return RiskResult(
        level: RiskLevel.high,
        label: 'HIGH',
        emoji: '🟠',
        color: AppColors.high,
        headline: 'High risk — take precautions now',
        recommendation:
        'Stay indoors. Avoid rivers, hills & flood zones. '
            'Prepare emergency kit. Monitor official alerts.',
        activeThreatTypes: threats,
      );
    } else if (score >= 15) {
      return RiskResult(
        level: RiskLevel.medium,
        label: 'MEDIUM',
        emoji: '🟡',
        color: AppColors.medium,
        headline: 'Moderate conditions — stay alert',
        recommendation:
        'Monitor weather updates. Avoid unnecessary travel. '
            'Keep emergency contacts ready.',
        activeThreatTypes: threats,
      );
    } else {
      return RiskResult(
        level: RiskLevel.low,
        label: 'LOW',
        emoji: '🟢',
        color: AppColors.low,
        headline: 'Conditions are currently safe',
        recommendation:
        'No immediate threats. Stay informed and keep emergency '
            'supplies stocked.',
        activeThreatTypes: threats.isEmpty ? ['No active threats'] : threats,
      );
    }
  }
}