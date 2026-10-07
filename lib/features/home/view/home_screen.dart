
import 'package:diaster_ngo_app/features/alerts/widgets/gradient_divider.dart';
import 'package:diaster_ngo_app/features/home/view_model/home_view_model.dart';
import 'package:diaster_ngo_app/features/home/widgets/earthquake_card.dart';
import 'package:diaster_ngo_app/features/home/widgets/flood_card.dart';
import 'package:diaster_ngo_app/features/home/widgets/risk_banner.dart';
import 'package:diaster_ngo_app/features/home/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<HomeViewModel>();
    if (vm.dashboard == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.loadDashboard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Disaster Dashboard'),
        actions: [
          Consumer<HomeViewModel>(
            builder: (_, vm, _) => IconButton(
              icon: vm.isRefreshing
                  ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.refresh, color: Colors.white),
              onPressed: vm.isRefreshing ? null : () => vm.refresh(),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          if ((vm.state == HomeState.loading ||
              vm.state == HomeState.idle) &&
              vm.dashboard == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Detecting location & loading disaster data...',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          if (vm.state == HomeState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white38, size: 56),
                    const SizedBox(height: 16),
                    Text(vm.error ?? 'Unknown error',
                        style: const TextStyle(color: Colors.white70, fontSize: 15),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue),
                      onPressed: () => vm.loadDashboard(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final d = vm.dashboard!;
          return RefreshIndicator(
            onRefresh: vm.refresh,
            color: AppColors.primaryBlue,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const GradientDivider(),
                const SizedBox(height: 20),
                // Location header
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        d.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                // ── Overall Risk Banner ──
                RiskBanner(risk: d.overallRisk),
                const SizedBox(height: 20),
                WeatherCard(weather: d.weather),
                const SizedBox(height: 16),

                // ── Earthquake Card ──
                EarthquakeCard(
                  quakes: d.nearbyEarthquakes,
                ),
                const SizedBox(height: 16),

                // ── Flood Card ──
                FloodCard(flood: d.flood),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}