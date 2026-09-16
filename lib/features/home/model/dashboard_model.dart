import 'weather_model.dart';
import 'earthquake_model.dart';
import 'flood_model.dart';
import '../../../core/utils/risk_calculator.dart';

class DashboardModel {
  final String locationName;
  final String country;
  final double latitude;
  final double longitude;
  final WeatherModel weather;
  final List<EarthquakeModel> nearbyEarthquakes;
  final FloodModel flood;
  final RiskResult overallRisk;
  final DateTime lastUpdated;

  const DashboardModel({
    required this.locationName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.weather,
    required this.nearbyEarthquakes,
    required this.flood,
    required this.overallRisk,
    required this.lastUpdated,
  });
}