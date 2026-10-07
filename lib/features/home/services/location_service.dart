// import 'package:geolocator/geolocator.dart';
// import '../../../core/constants/api_constants.dart';
// import '../../../core/network/network_api_service.dart';
//
// class LocationResult {
//   final double lat;
//   final double lon;
//   final String city;
//   final String country;
//   const LocationResult({
//     required this.lat,
//     required this.lon,
//     required this.city,
//     required this.country,
//   });
// }
// class LocationService {
//   final NetworkApiService _apiService = NetworkApiService();
//   Future<LocationResult> getCurrentLocation() async {
//     Position? position;
//     try {
//      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         position = await Geolocator.getLastKnownPosition();
//       }
//       if (position == null) {
//         LocationPermission permission = await Geolocator.checkPermission();
//         if (permission == LocationPermission.denied) {
//           permission = await Geolocator.requestPermission();
//         }
//     if (permission == LocationPermission.deniedForever) {
//           position = await Geolocator.getLastKnownPosition();
//        } else if (permission ==
//        LocationPermission.whileInUse || permission == LocationPermission.always) {
//           position = await Geolocator.getCurrentPosition(
//             locationSettings: const LocationSettings(
//               accuracy: LocationAccuracy.medium,
//             ));
//         }
//       }
//     } catch (_) {
//       position = await Geolocator.getLastKnownPosition();
//     }
//
//     if (position == null) {
//       return const LocationResult(
//         lat: 0,
//         lon: 0,
//         city: 'Unknown location',
//         country: '',
//       );
//     }
//     return _buildResultFromPosition(position);
//   }
//   Future<LocationResult> _buildResultFromPosition(
//       Position position,
//       ) async {
//     final uri = Uri.parse(ApiConstants.geocodeUrl).replace(
//       queryParameters: {
//         'lat': position.latitude.toString(),
//         'lon': position.longitude.toString(),
//         'format': 'json',
//       },
//     );
//     ///Api Call
//     try {
//       final data = await _apiService.getApi(uri.toString(),
//         headers: {
//           'User-Agent': 'DisasterNGOApp/1.0',
//           'Accept-Language': 'en',
//         },
//       );
//       if (data is Map<String, dynamic>) {
//         final address = data['address'] as Map<String, dynamic>? ?? {};
//         final city = findCityFromAddress(address);
//         final country = address['country']?.toString().trim() ?? '';
//         if (city.isNotEmpty) {
//           return LocationResult(
//             lat: position.latitude,
//             lon: position.longitude,
//             city: city,
//             country: country,
//           );
//         }
//       }
//     } catch (_) {
//       // Reverse geocoding failed.
//     }
//     return LocationResult(
//       lat: position.latitude,
//       lon: position.longitude,
//       city: '${position.latitude.toStringAsFixed(4)}, '
//           '${position.longitude.toStringAsFixed(4)}',
//       country: '',
//     );
//   }
//
//   static String findCityFromAddress(
//       Map<String, dynamic> address,
//       ) {
//     final possibleCities = [
//       address['city'],
//       address['town'],
//       address['municipality'],
//       address['village'],
//       address['city_district'],
//       address['county'],
//       address['state_district'],
//       address['state'],
//       address['province'],
//     ];
//     for (final value in possibleCities) {
//       final city = value?.toString().trim();
//       if (city != null && city.isNotEmpty) {
//         return city
//             .replaceAll(' City Tehsil', '')
//             .replaceAll(' Tehsil', '')
//             .replaceAll(' District', '')
//             .trim();
//       }
//     }
//     return '';
//   }
//
// }
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/network_api_service.dart';

class LocationResult {
  final double lat;
  final double lon;
  final String location;
  const LocationResult({
    required this.lat,
    required this.lon,
    required this.location,
  });
}

class LocationService {
  final NetworkApiService _apiService = NetworkApiService();
  Future<LocationResult> getCurrentLocation() async {
    Position? position;
    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        position = await Geolocator.getLastKnownPosition();
      }
      if (position == null) {
        LocationPermission permission =
        await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.deniedForever) {
          position = await Geolocator.getLastKnownPosition();
        } else if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,),
          );
        }
      }
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }
    if (position == null) {
      return const LocationResult(
        lat: 0,
        lon: 0,
        location: 'Unknown location',
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
    // API Call
    try {
      final data = await _apiService.getApi(uri.toString(),
        headers: {
          'User-Agent': 'DisasterNGOApp/1.0',
          'Accept-Language': 'en',
        },
      );
    if (data is Map<String, dynamic>) {
      final address = data['address'] as Map<String, dynamic>? ?? {};
      final village = address['village']?.toString().trim() ?? '';
      final city = address['city']?.toString().trim() ?? '';
      final country = address['country']?.toString().trim() ?? '';
      final location = [
        village,
        city,
        country
      ].where((value) => value.isNotEmpty).join(', ');
        if (location.isNotEmpty) {
          return LocationResult(
            lat: position.latitude,
            lon: position.longitude,
            location: location,
          );
        }
    }
    } catch (_) {
      // Reverse geocoding failed.
    }
    return LocationResult(
      lat: position.latitude,
      lon: position.longitude,
      location:
      '${position.latitude.toStringAsFixed(4)}, '
          '${position.longitude.toStringAsFixed(4)}',
    );
  }
}