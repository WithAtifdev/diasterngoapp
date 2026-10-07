import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_api_service.dart';

class FloodService {
  final NetworkApiService _apiService = NetworkApiService();
  Future<FloodModel> fetch({
     required double lat,
     required double lon,
  }) async {
    final uri = Uri.parse(ApiConstants.floodUrl).replace(
      queryParameters: {
        'latitude': lat.toString(),
        'longitude': lon.toString(),
        'daily': 'river_discharge_mean',
        'forecast_days': '1',
      },
    );
    try {
      final data = await _apiService.getApi(uri.toString());
      return FloodModel.fromJson(data);
    } catch (_) {
      return FloodModel.empty();
    }
  }
}