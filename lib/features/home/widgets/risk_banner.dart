import 'package:flutter/material.dart';
import '../../../../core/utils/risk_calculator.dart';

class RiskBanner extends StatelessWidget {
  final RiskResult risk;
  const RiskBanner({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: risk.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: risk.color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: risk.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${risk.emoji} Risk Level: ${risk.label}',
                  style: TextStyle(
                    color: risk.color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(risk.headline,
              style: const TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12),
          const SizedBox(height: 12),
          const Text('Safety Recommendation',
              style: TextStyle(
                  color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(risk.recommendation,
                style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
          ),
        ],
      ),
    );
  }
}