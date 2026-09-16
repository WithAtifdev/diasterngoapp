import 'package:diaster_ngo_app/features/home/model/weather_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';


class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return _card(
      title: 'Weather Conditions',
      icon: Icons.cloud,
      color: AppColors.primaryBlue,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('${weather.weatherEmoji} ${weather.temperatureCelsius.toStringAsFixed(1)}°C',
                  'Temperature'),
              _stat('🌧 ${weather.precipitationMm.toStringAsFixed(1)} mm', 'Rainfall'),
              _stat('💨 ${weather.windSpeedKph.toStringAsFixed(0)} km/h', 'Wind'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('💦 ${weather.humidity.toStringAsFixed(0)}%', 'Humidity'),
              _stat('🌬 ${weather.windGustKph.toStringAsFixed(0)} km/h', 'Gusts'),
              _stat('☀️ ${weather.uvIndex.toStringAsFixed(1)}', 'UV Index'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              weather.condition,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.primaryBlue, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
    children: [
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(label,
          style: const TextStyle(color: Colors.white54, fontSize: 11)),
    ],
  );
}

Widget _card({
  required String title,
  required IconData icon,
  required Color color,
  required Widget child,
}) {
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
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}