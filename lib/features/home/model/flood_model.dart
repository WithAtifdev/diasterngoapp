class FloodModel {
  final double riverDischarge; // m³/s — higher = more flooding risk
  final String riskLabel;
  final DateTime fetchedAt;

  const FloodModel({
    required this.riverDischarge,
    required this.riskLabel,
    required this.fetchedAt,
  });

  factory FloodModel.fromJson(Map<String, dynamic> json) {
    // Open-Meteo Flood returns hourly river_discharge array
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};
    final discharges = (hourly['river_discharge'] as List?)
        ?.whereType<num>()
        .map((e) => e.toDouble())
        .toList() ??
        [0.0];
    final latest = discharges.isNotEmpty ? discharges.last : 0.0;
    return FloodModel(
      riverDischarge: latest,
      riskLabel:      label(latest),
      fetchedAt:      DateTime.now(),
    );
  }

  static String label(double discharge) {
    if (discharge > 500) return 'SEVERE';
    if (discharge > 200) return 'HIGH';
    if (discharge > 80)  return 'MODERATE';
    return 'NORMAL';
  }

  factory FloodModel.empty() => FloodModel(
    riverDischarge: 0,
    riskLabel: 'UNKNOWN',
    fetchedAt: DateTime.now(),
  );
}