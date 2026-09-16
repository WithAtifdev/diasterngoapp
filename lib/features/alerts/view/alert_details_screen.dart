import 'package:flutter/material.dart';

class AlertDetailsScreen extends StatelessWidget {
  final String alertId;
  final String title;
  final String description;
  final String severity;
  final String source;
  final DateTime? createdAt;

  const AlertDetailsScreen({
    super.key,
    required this.alertId,
    required this.title,
    required this.description,
    required this.severity,
    required this.source,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ID: $alertId',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Severity: ', style: TextStyle(color: Colors.white70)),
                Text(
                  severity,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Source: ', style: TextStyle(color: Colors.white70)),
                Text(
                  source,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (createdAt != null)
              Text(
                'Created: ${createdAt!.toIso8601String()}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
