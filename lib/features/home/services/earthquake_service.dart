import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_api_service.dart';

class EarthquakeService {
  final NetworkApiService _apiService = NetworkApiService();
  Future<List<EarthquakeModel>> fetchNearby({
    required double lat,
    required double lon,
    double radiusKm = ApiConstants.earthquakeRadiusKm,
  }) async {
    final uri = Uri.parse(ApiConstants.earthquakeUrl).replace(
      queryParameters: {
        'format': 'geojson',
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'maxradiuskm': radiusKm.toString(),
        'minmagnitude': '2.5',
        'orderby': 'time',
      },
    );
    try {
      final data = await _apiService.getApi(uri.toString());
      final features = (data['features'] as List?) ?? [];
      return features.whereType<Map<String, dynamic>>().map(
       (feature) => EarthquakeModel.fromGeoJson(feature)).toList();
    } catch (_) {
      return [];
    }
  }
}