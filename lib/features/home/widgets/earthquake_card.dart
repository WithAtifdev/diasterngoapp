import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';


class EarthquakeCard extends StatelessWidget {
  final List<EarthquakeModel> quakes;
  final double userLat;
  final double userLon;
  const EarthquakeCard({
    super.key,
    required this.quakes,
    required this.userLat,
    required this.userLon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.vibration, color: AppColors.earthquake, size: 20),
              const SizedBox(width: 8),
              const Text('Nearby Earthquakes',
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.earthquake.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${quakes.length} found',
                  style: const TextStyle(color: AppColors.earthquake, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (quakes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('No earthquakes within 500 km in last 24h',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
              ),
            )
          else
            ...quakes.take(3).map((q) => _QuakeTile(quake: q)),
        ],
      ),
    );
  }
}

class _QuakeTile extends StatelessWidget {
  final EarthquakeModel quake;
  const _QuakeTile({required this.quake});

  @override
  Widget build(BuildContext context) {
    final color = quake.magnitude >= 5.0
        ? AppColors.high
        : quake.magnitude >= 3.5
        ? AppColors.medium
        : AppColors.low;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'M${quake.magnitude.toStringAsFixed(1)}',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quake.place,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  '${quake.severityLabel} · Depth ${quake.depthKm.toStringAsFixed(0)} km · ${TimeFormatter.timeAgo(quake.occurredAt)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(quake.severityEmoji, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}