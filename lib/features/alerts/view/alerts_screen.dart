


import 'package:diaster_ngo_app/core/constants/app_colors.dart';
import 'package:diaster_ngo_app/features/alerts/model/alert_model.dart';
import 'package:diaster_ngo_app/features/alerts/view_model/alerts_view_model.dart';
import 'package:diaster_ngo_app/features/alerts/widgets/gradient_divider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {


  @override

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertsViewModel>().initialize();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Updates'),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<AlertsViewModel>(
            builder: (_, vm, _) => IconButton(
              icon: vm.isLoadingLive
                  ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => vm.fetchLiveAlerts(),
              tooltip: 'Refresh alerts',
            ),
          ),
        ],
      ),
      body: Consumer<AlertsViewModel>(
        builder: (context, vm, _) {
          final alerts = vm.allAlerts;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const GradientDivider(),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  _statBadge('${alerts.length}', 'Total Alerts', AppColors.primaryBlue),
                  const SizedBox(width: 10),
                  _statBadge('${vm.highPriorityAlerts.length}', 'High Priority', AppColors.high),
                  const SizedBox(width: 10),
                  _statBadge(vm.isLoadingLive ? '...' : 'Live', 'Active Monitoring', AppColors.low),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Active Disaster Alerts',
                  style: TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              if (alerts.isEmpty && !vm.isLoadingLive)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No active alerts in your area',
                        style: TextStyle(color: Colors.white54)),
                  ),
                )
              else
                ...alerts.map((alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _AlertCard(alert: alert),
                )),

              if (vm.isLoadingLive)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.primaryBlue)),
                        SizedBox(width: 10),
                        Text('Fetching live data...',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _statBadge(String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    ),
  );
}

class _AlertCard extends StatelessWidget {
  final AlertModel alert;
  const _AlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: alert.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(alert.icon, color: alert.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(alert.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: alert.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(alert.sourceLabel,
                          style: TextStyle(color: alert.color, fontSize: 10)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(alert.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(alert.timeLabel,
                        style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}