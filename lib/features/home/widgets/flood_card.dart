import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class FloodCard extends StatelessWidget {
  final FloodModel flood;

  const FloodCard({
    super.key,
    required this.flood,
  });

  @override
  Widget build(BuildContext context) {
    final color = flood.riskLabel == 'SEVERE'
        ? AppColors.extreme
        : flood.riskLabel == 'HIGH'
        ? AppColors.high
        : flood.riskLabel == 'MODERATE'
        ? AppColors.medium
        : AppColors.low;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water,
                color: AppColors.flood,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Flood Monitor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'River Discharge',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${flood.riverDischarge.toStringAsFixed(0)} m³/s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  flood.riskLabel,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (flood.riverDischarge / 600).clamp(0.0, 1.0),
              backgroundColor: Colors.white10,
              color: color,
              minHeight: 6,
            ),
          ),

          const SizedBox(height: 6),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Normal',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
              Text(
                'Severe',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}