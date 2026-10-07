class FloodModel {
  final double riverDischarge;
  final String riskLabel;
  final DateTime fetchedAt;

  const FloodModel({
    required this.riverDischarge,
    required this.riskLabel,
    required this.fetchedAt,
  });

  factory FloodModel.fromJson(Map<String, dynamic> json) {
    final daily = json['daily'] as Map<String, dynamic>? ?? {};
    final discharges = (daily['river_discharge_mean'] as List?)
   ?.whereType<num>().map((e) => e.toDouble()).toList() ?? [0.0];
    final latest = discharges.isNotEmpty ? discharges.last : 0.0;
    return FloodModel(
      riverDischarge: latest,
      riskLabel: label(latest),
      fetchedAt: DateTime.now(),
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