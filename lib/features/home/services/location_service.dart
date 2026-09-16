
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';

class LocationResult {
  final double lat;
  final double lon;
  final String city;
  final String country;

  const LocationResult({
    required this.lat,
    required this.lon,
    required this.city,
    required this.country,
  });
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    Position? position;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        LocationPermission permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.deniedForever) {
          position = await Geolocator.getLastKnownPosition();
        } else if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
            ),
          );
        }
      }
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }

    if (position == null) {
      return LocationResult(
        lat: 0,
        lon: 0,
        city: 'Unknown location',
        country: '',
      );
    }

    return _buildResultFromPosition(position);
  }

  Future<LocationResult> _buildResultFromPosition(Position position) async {
    final uri = Uri.parse(ApiConstants.geocodeUrl).replace(
      queryParameters: {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'format': 'json',
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'DisasterNGOApp/1.0',
          'Accept-Language': 'en',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          final address = decoded['address'] as Map<String, dynamic>? ?? {};
          final city = findCityFromAddress(address);
          final country = address['country']?.toString().trim() ?? '';

          if (city.isNotEmpty) {
            return LocationResult(
              lat: position.latitude,
              lon: position.longitude,
              city: city,
              country: country,
            );
          }
        }
      }
    } catch (_) {
      // Reverse geocoding may fail; keep the real coordinates.
    }

    return LocationResult(
      lat: position.latitude,
      lon: position.longitude,
      city: '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
      country: '',
    );
  }

  static String findCityFromAddress(Map<String, dynamic> address) {
    final possibleCities = [
      address['city'],
      address['town'],
      address['municipality'],
      address['village'],
      address['city_district'],
      address['county'],
      address['state_district'],
      address['state'],
      address['province'],
    ];

    for (final value in possibleCities) {
      final city = value?.toString().trim();

      if (city != null && city.isNotEmpty) {
        return city
            .replaceAll(' City Tehsil', '')
            .replaceAll(' Tehsil', '')
            .replaceAll(' District', '')
            .trim();
      }
    }

    return '';
  }
}