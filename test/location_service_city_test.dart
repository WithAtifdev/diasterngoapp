import 'package:diaster_ngo_app/features/home/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LocationService extracts the best available city from the geocoder address map', () {
    final address = <String, dynamic>{
      'city': 'Peshawar',
      'town': 'Nowshera',
      'country': 'Pakistan',
    };

    expect(LocationService.findCityFromAddress(address), 'Peshawar');
  });

  test('LocationService falls back to city_district when city and town fields are missing', () {
    final address = <String, dynamic>{
      'city_district': 'Peshawar',
      'country': 'Pakistan',
    };

    expect(LocationService.findCityFromAddress(address), 'Peshawar');
  });
}
