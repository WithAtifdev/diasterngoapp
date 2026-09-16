import 'dart:convert';
import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';


class FloodService {
  Future<FloodModel> fetch({required double lat, required double lon}) async {
    final uri = Uri.parse(ApiConstants.floodUrl).replace(queryParameters: {
      'latitude':  lat.toString(),
      'longitude': lon.toString(),
      'daily':     'river_discharge_mean',
      'forecast_days': '1',
    });

    try {
      final res = await http.get(uri).timeout(
          const Duration(seconds: ApiConstants.timeoutSeconds));
      if (res.statusCode != 200) return FloodModel.empty();

      // Open-Meteo Flood returns daily not hourly - adapt parsing
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final daily = data['daily'] as Map<String, dynamic>? ?? {};
      final discharges = (daily['river_discharge_mean'] as List?)
          ?.whereType<num>()
          .map((e) => e.toDouble())
          .toList() ?? [0.0];
      final latest = discharges.isNotEmpty ? discharges.first : 0.0;
      return FloodModel(
        riverDischarge: latest,
        riskLabel: _label(latest),
        fetchedAt: DateTime.now(),
      );
    } catch (_) {
      return FloodModel.empty();
    }
  }

  String _label(double d) {
    if (d > 500) return 'SEVERE';
    if (d > 200) return 'HIGH';
    if (d > 80)  return 'MODERATE';
    return 'NORMAL';
  }
}