import 'package:diaster_ngo_app/features/home/model/flood_model.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_api_service.dart';

class FloodService {
  final NetworkApiService _apiService = NetworkApiService();

  Future<FloodModel> fetch({
    required double lat,
    required double lon,
  }) async {
    final uri = Uri.parse(
      ApiConstants.floodUrl,
    ).replace(
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'daily': 'river_discharge_mean',
        'forecast_days': '1',
      },
    );

    try {
      final data = await _apiService.getApi(uri.toString());

      final daily =
          data['daily'] as Map<String, dynamic>? ?? {};

      final discharges =
          (daily['river_discharge_mean'] as List?)
              ?.whereType<num>()
              .map((e) => e.toDouble())
              .toList() ??
              [0.0];

      final latest =
      discharges.isNotEmpty ? discharges.first : 0.0;

      return FloodModel(
        riverDischarge: latest,
        riskLabel: FloodModel.label(latest),
        fetchedAt: DateTime.now(),
      );
    } catch (_) {
      return FloodModel.empty();
    }
  }
}