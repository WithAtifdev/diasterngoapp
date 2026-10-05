import 'package:diaster_ngo_app/features/home/model/weather_model.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_api_service.dart';

class WeatherService {
  final NetworkApiService _apiService = NetworkApiService();

  Future<WeatherModel> fetch({
    required double lat,
    required double lon,
  }) async {
    final uri = Uri.parse(
      ApiConstants.weatherUrl,
    ).replace(
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'current': [
          'temperature_2m',
          'relative_humidity_2m',
          'precipitation',
          'weather_code',
          'wind_speed_10m',
          'wind_gusts_10m',
          'uv_index',
        ].join(','),
        'timezone': 'auto',
        'forecast_days': '1',
      },
    );

    try {
      final data = await _apiService.getApi(
        uri.toString(),
        headers: {
          'Accept': 'application/json',
        },
      );

      return WeatherModel.fromJson(data);
    } catch (_) {
      return WeatherModel.empty();
    }
  }
}