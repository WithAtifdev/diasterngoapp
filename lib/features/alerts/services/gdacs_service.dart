import 'package:diaster_ngo_app/core/constants/api_constants.dart';
import 'package:diaster_ngo_app/core/network/network_api_service.dart';
import 'package:diaster_ngo_app/features/alerts/model/alert_model.dart';

class GdacsService {
  final NetworkApiService _apiService = NetworkApiService();

  Future<List<AlertModel>> fetchAlerts() async {
    final uri = Uri.parse(
      ApiConstants.gdacsUrl,
    ).replace(
      queryParameters: {
        // Earthquake, Tropical Cyclone, Flood, Volcano, etc.
        'eventlist': 'EQ;TC;FL;VO',

        // Recent alerts
        'fromdate': DateTime.now()
            .subtract(const Duration(days: 7))
            .toIso8601String()
            .split('T')
            .first,

        'todate': DateTime.now()
            .toIso8601String()
            .split('T')
            .first,

        // All alert levels
        'alertlevel': 'red;orange;green',
      },
    );

    try {
      final data = await _apiService.getApi(
        uri.toString(),
        headers: {
          'Accept': 'application/json',
        },
      );

      final features = (data['features'] as List?) ?? [];

      return features
          .whereType<Map<String, dynamic>>()
          .map(AlertModel.fromGdacs)
          .toList();
    } catch (_) {
      return [];
    }
  }
}