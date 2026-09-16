import 'dart:convert';
import 'dart:math' as math;
import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';


class EarthquakeService {
  /// Fetches all M2.5+ quakes from last 24h globally,
  /// then filters to within [radiusKm] of user location.
  Future<List<EarthquakeModel>> fetchNearby({
    required double lat,
    required double lon,
    double radiusKm = 500,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(ApiConstants.earthquakeUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: ApiConstants.timeoutSeconds));

      if (res.statusCode != 200) return <EarthquakeModel>[];

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final features = (data['features'] as List?)?.cast<Map<String, dynamic>>() ?? const [];

      return features
          .map((f) => EarthquakeModel.fromGeoJson(f))
          .where((q) => _distKm(lat, lon, q.latitude, q.longitude) <= radiusKm)
          .toList()
        ..sort((a, b) => b.magnitude.compareTo(a.magnitude));
    } catch (_) {
      return <EarthquakeModel>[];
    }
  }

  double _distKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(lat1)) * math.cos(_rad(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return r * 2 * math.asin(math.sqrt(a));
  }

  double _rad(double d) => d * math.pi / 180;
}