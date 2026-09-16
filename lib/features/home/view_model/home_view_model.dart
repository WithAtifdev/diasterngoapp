
import 'package:diaster_ngo_app/features/home/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/earthquake_service.dart';
import '../services/flood_service.dart';
import '../services/location_service.dart';
import '../../../core/utils/risk_calculator.dart';

enum HomeState { idle, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final WeatherService _weatherSvc;
  final EarthquakeService _quakeSvc;
  final FloodService _floodSvc;
  final LocationService _locationSvc;

  HomeViewModel(
      this._weatherSvc,
      this._quakeSvc,
      this._floodSvc,
      this._locationSvc,
      );

  HomeState _state = HomeState.idle;
  DashboardModel? _dashboard;
  String? _error;

  bool _isRefreshing = false;
  bool _isLoading = false;

  dynamic _cachedLocation;

  HomeState get state => _state;

  DashboardModel? get dashboard => _dashboard;

  String? get error => _error;

  bool get isRefreshing => _isRefreshing;

  Future<void> loadDashboard({
    bool forceRefresh = false,
  }) async {
    if (_isLoading) return;

    _isLoading = true;

    // Show loader ONLY first time
    if (_dashboard == null) {
      _state = HomeState.loading;
      notifyListeners();
    }

    _error = null;

    try {
      /// =========================
      /// USE CACHED LOCATION
      /// =========================
      _cachedLocation ??=
      await _locationSvc.getCurrentLocation();

      final loc = _cachedLocation;

      /// =========================
      /// FETCH ALL APIs PARALLEL
      /// =========================
      final results = await Future.wait([
        _weatherSvc.fetch(
          lat: loc.lat,
          lon: loc.lon,
        ),

        _quakeSvc.fetchNearby(
          lat: loc.lat,
          lon: loc.lon,
          radiusKm: 500,
        ),

        _floodSvc.fetch(
          lat: loc.lat,
          lon: loc.lon,
        ),
      ]);

      final weather = results[0] as dynamic;
      final quakes = results[1] as dynamic;
      final flood = results[2] as dynamic;

      /// =========================
      /// CALCULATE RISK
      /// =========================
      final risk = RiskCalculator.calculate(
        weather: weather,
        nearbyQuakes: quakes,
        flood: flood,
      );

      /// =========================
      /// UPDATE DASHBOARD
      /// =========================
      _dashboard = DashboardModel(
        locationName: loc.city,
        country: loc.country,
        latitude: loc.lat,
        longitude: loc.lon,
        weather: weather,
        nearbyEarthquakes: quakes,
        flood: flood,
        overallRisk: risk,
        lastUpdated: DateTime.now(),
      );

      _state = HomeState.loaded;
    } catch (e) {
      _error = _friendlyError(e.toString());

      // Show error ONLY if no old data exists
      if (_dashboard == null) {
        _state = HomeState.error;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// =========================
  /// REFRESH
  /// =========================
  Future<void> refresh() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    notifyListeners();

    // OLD DATA WILL STAY
    await loadDashboard(
      forceRefresh: true,
    );

    _isRefreshing = false;
    notifyListeners();
  }

  /// =========================
  /// FRIENDLY ERROR
  /// =========================
  String _friendlyError(String raw) {
    if (raw.contains(
      'Location services disabled',
    )) {
      return 'Enable location services to load disaster data.';
    }

    if (raw.contains('denied')) {
      return 'Location permission required. Allow in Settings.';
    }

    if (raw.contains('SocketException') ||
        raw.contains('TimeoutException')) {
      return 'No internet connection. Check your network.';
    }

    return 'Could not load data. Tap refresh to retry.';
  }
}