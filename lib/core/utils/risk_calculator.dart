
import 'dart:ui';
import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import 'package:diaster_ngo_app/features/home/model/weather_model.dart';

import '../constants/app_colors.dart';

enum RiskLevel {extreme, high, medium,low}

class RiskResult {
  final RiskLevel level;
  final int score;
  final List<String> activeThreats;

  const RiskResult({
    required this.level,
    required this.score,
    required this.activeThreats,
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

    final strongQuakes = nearbyQuakes
        .where((q) => q.magnitude >= 5.0)
        .toList();
    final moderateQuakes = nearbyQuakes
        .where((q) => q.magnitude >= 3.5 && q.magnitude < 5.0)
        .toList();

    if (strongQuakes.isNotEmpty) {
      score += 40;
      threats.add(
        'Earthquake M${strongQuakes.first.magnitude.toStringAsFixed(1)}+',
      );
    } else if (moderateQuakes.isNotEmpty) {
      score += 20;
      threats.add('Seismic Activity');
    }


    if (flood.riverDischarge > 500) {
      score += 35;
      threats.add('Severe Flooding');
    } else if (flood.riverDischarge > 200) {
      score += 20;
      threats.add('Flood Warning');
    }

    if (weather.precipitationMm > 50 ||
        weather.windSpeedKph > 80) {
      score += 30;
      threats.add('Extreme Weather');
    } else if (weather.precipitationMm > 20 ||
        weather.windSpeedKph > 50) {
      score += 15;
      threats.add('Heavy Rain');
    }

    if (weather.temperatureCelsius > 45 ||
        weather.temperatureCelsius < -10) {
      score += 15;
      threats.add('Temperature Extreme');
    }

   /// Final risk level
    final RiskLevel level;
    if (score >= 50) {
      level = RiskLevel.extreme;
    } else if (score >= 30) {
      level = RiskLevel.high;
    } else if (score >= 15) {
      level = RiskLevel.medium;
    } else {
      level = RiskLevel.low;
    }

    return RiskResult(
      level: level,
      score: score,
      activeThreats: threats.isEmpty
          ? ['No active threats']
          : threats,
    );
  }
}

/// UI information for each risk level.
extension RiskLevelExtension on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.extreme:
        return 'EXTREME';
      case RiskLevel.high:
        return 'HIGH';
      case RiskLevel.medium:
        return 'MEDIUM';
      case RiskLevel.low:
        return 'LOW';
    }
  }
  String get emoji {
    switch (this) {
      case RiskLevel.extreme:
        return '🔴';
      case RiskLevel.high:
        return '🟠';
      case RiskLevel.medium:
        return '🟡';
      case RiskLevel.low:
        return '🟢';
    }
  }

  String get headline {
    switch (this) {
      case RiskLevel.extreme:
        return 'Extreme disaster risk detected';
      case RiskLevel.high:
        return 'High risk — take precautions now';
      case RiskLevel.medium:
        return 'Moderate conditions — stay alert';
      case RiskLevel.low:
        return 'Conditions are currently safe';
    }
  }

  String get recommendation {
    switch (this) {
      case RiskLevel.extreme:
        return 'EVACUATE immediately if authorities advise. '
            'Move to high ground. Call emergency services. '
            'Do not use elevators.';

      case RiskLevel.high:
        return 'Stay indoors. Avoid rivers, hills & flood zones. '
            'Prepare emergency kit. Monitor official alerts.';

      case RiskLevel.medium:
        return 'Monitor weather updates. Avoid unnecessary travel. '
            'Keep emergency contacts ready.';

      case RiskLevel.low:
        return 'No immediate threats. Stay informed and keep '
            'emergency supplies stocked.';
    }
  }

  Color get color {
    switch (this) {
      case RiskLevel.extreme:
        return AppColors.extreme;
      case RiskLevel.high:
        return AppColors.high;
      case RiskLevel.medium:
        return AppColors.medium;
      case RiskLevel.low:
        return AppColors.low;
    }
  }
}