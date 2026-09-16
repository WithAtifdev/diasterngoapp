import 'dart:convert';
import 'package:diaster_ngo_app/features/home/model/weather_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';


class WeatherService {
  Future<WeatherModel> fetch({required double lat, required double lon}) async {
    try {
      final uri = Uri.parse(ApiConstants.weatherUrl).replace(queryParameters: {
        'latitude':  lat.toString(),
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
      });

      final res = await http.get(uri, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      if (res.statusCode != 200) return WeatherModel.empty();
      return WeatherModel.fromJson(jsonDecode(res.body));
    } catch (_) {
      return WeatherModel.empty();
    }
  }
}