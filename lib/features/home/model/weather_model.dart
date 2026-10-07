class WeatherModel {
  final double temperatureCelsius;
  final double precipitationMm;
  final double windSpeedKph;
  final double windGustKph;
  final int weatherCode;
  final double humidity;
  final double uvIndex;
  final String condition;

  const WeatherModel({
    required this.temperatureCelsius,
    required this.precipitationMm,
    required this.windSpeedKph,
    required this.windGustKph,
    required this.weatherCode,
    required this.humidity,
    required this.uvIndex,
    required this.condition,
  });

  factory WeatherModel.empty() => const WeatherModel(
    temperatureCelsius: 0,
    precipitationMm: 0,
    windSpeedKph: 0,
    windGustKph: 0,
    weatherCode: 0,
    humidity: 0,
    uvIndex: 0,
    condition: 'Clear Sky',
  );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    final code = (c['weather_code'] ?? 0) as int;
    return WeatherModel(
      temperatureCelsius: (c['temperature_2m'] ?? 0).toDouble(),
      precipitationMm: (c['precipitation'] ?? 0).toDouble(),
      windSpeedKph: (c['wind_speed_10m'] ?? 0).toDouble(),
      windGustKph: (c['wind_gusts_10m'] ?? 0).toDouble(),
      weatherCode: code,
      humidity: (c['relative_humidity_2m'] ?? 0).toDouble(),
      uvIndex: (c['uv_index'] ?? 0).toDouble(),
      condition: _wmoLabel(code),
    );
  }

  static String _wmoLabel(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mainly Clear';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Snow';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with Hail';
      default:
        return 'Unknown';
    }
  }
  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
        return '🌤️';
      case 2:
        return '⛅';
      case 3:
        return '☁️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return '🌧️';
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return '🌧️';
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return '❄️';
      case 80:
      case 81:
      case 82:
        return '🌦️';
      case 95:
      case 96:
      case 99:
        return '⛈️';
      default:
        return '🌡️';
    }
  }

}