class WeatherModel {
  final double temperatureCelsius;
  final double precipitationMm;
  final double windSpeedKph;
  final double windGustKph;
  final int    weatherCode;      // WMO code
  final double humidity;
  final double uvIndex;
  final String condition;        // derived label

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
      temperatureCelsius: (c['temperature_2m']    ?? 0).toDouble(),
      precipitationMm:    (c['precipitation']     ?? 0).toDouble(),
      windSpeedKph:       (c['wind_speed_10m']    ?? 0).toDouble(),
      windGustKph:        (c['wind_gusts_10m']    ?? 0).toDouble(),
      weatherCode:        code,
      humidity:           (c['relative_humidity_2m'] ?? 0).toDouble(),
      uvIndex:            (c['uv_index']          ?? 0).toDouble(),
      condition:          _wmoLabel(code),
    );
  }

  static String _wmoLabel(int code) {
    if (code == 0) return 'Clear Sky';
    if (code <= 3) return 'Partly Cloudy';
    if (code <= 9) return 'Fog';
    if (code <= 19) return 'Drizzle';
    if (code <= 29) return 'Rain';
    if (code <= 39) return 'Snow';
    if (code <= 49) return 'Haze';
    if (code <= 59) return 'Drizzle';
    if (code <= 69) return 'Rain';
    if (code <= 79) return 'Snowfall';
    if (code <= 84) return 'Rain Showers';
    if (code <= 94) return 'Thunderstorm';
    return 'Severe Thunderstorm';
  }

  String get weatherEmoji {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode <= 49) return '🌫️';
    if (weatherCode <= 69) return '🌧️';
    if (weatherCode <= 79) return '❄️';
    if (weatherCode <= 84) return '🌦️';
    return '⛈️';
  }
}