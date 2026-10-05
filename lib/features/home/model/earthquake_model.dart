import 'dart:math' as math;
class EarthquakeModel {
  final String id;
  final double magnitude;
  final String place;
  final double latitude;
  final double longitude;
  final double depthKm;
  final DateTime occurredAt;
  final String url;

  const EarthquakeModel({
    required this.id,
    required this.magnitude,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.depthKm,
    required this.occurredAt,
    required this.url,
  });

  factory EarthquakeModel.fromGeoJson(Map<String, dynamic> feature) {
    final props = feature['properties'] as Map<String, dynamic>;
    final coords = (feature['geometry']['coordinates']) as List;
    return EarthquakeModel(
      id:          feature['id'] ?? '',
      magnitude:   (props['mag'] ?? 0).toDouble(),
      place:       props['place'] ?? 'Unknown location',
      latitude:    (coords[1] as num).toDouble(),
      longitude:   (coords[0] as num).toDouble(),
      depthKm:     (coords[2] as num).toDouble(),
      occurredAt:  DateTime.fromMillisecondsSinceEpoch(
          (props['time'] as int? ?? 0)),
      url:         props['url'] ?? '',
    );
  }

  String get severityLabel {
    if (magnitude >= 7.0) return 'Major';
    if (magnitude >= 5.0) return 'Strong';
    if (magnitude >= 3.5) return 'Moderate';
    return 'Minor';
  }

  String get severityEmoji {
    if (magnitude >= 7.0) return '🔴';
    if (magnitude >= 5.0) return '🟠';
    if (magnitude >= 3.5) return '🟡';
    return '🟢';
  }

  /// Distance in km from a reference point (Haversine)
  double distanceFromKm(double lat, double lon) {
    const r = 6371.0;
    final dLat = _rad(latitude - lat);
    final dLon = _rad(longitude - lon);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_rad(lat)) *
                math.cos(_rad(latitude)) *
                math.sin(dLon / 2) *
                math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));
    return r * c;
  }
  static double _rad(double deg) {
    return deg * math.pi / 180;
  }

}