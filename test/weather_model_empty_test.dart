import 'package:diaster_ngo_app/features/home/model/weather_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('WeatherModel.empty should expose safe default values', () {
    final model = WeatherModel.empty();

    expect(model.temperatureCelsius, 0.0);
    expect(model.precipitationMm, 0.0);
    expect(model.windSpeedKph, 0.0);
    expect(model.windGustKph, 0.0);
    expect(model.weatherCode, 0);
    expect(model.humidity, 0.0);
    expect(model.uvIndex, 0.0);
    expect(model.condition, 'Clear Sky');
  });
}
