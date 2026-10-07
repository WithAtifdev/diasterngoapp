
import 'package:flutter/material.dart';
import 'package:diaster_ngo_app/features/home/model/dashboard_model.dart';
import 'package:diaster_ngo_app/features/home/model/weather_model.dart';
import 'package:diaster_ngo_app/features/home/model/earthquake_model.dart';
import 'package:diaster_ngo_app/features/home/model/flood_model.dart';
import '../../../core/app_exceptions/app_exception.dart';
import '../services/weather_service.dart';
import '../services/earthquake_service.dart';
import '../services/flood_service.dart';
import '../services/location_service.dart';
import '../../../core/utils/risk_calculator.dart';

enum HomeState {
  idle,
  loading,
  loaded,
  error,
}

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
  LocationResult? _location;
  HomeState get state => _state;
  DashboardModel? get dashboard => _dashboard;
  String? get error => _error;
  bool get isRefreshing => _isRefreshing;

  Future<void> loadDashboard() async {
    if (_isLoading) return;
    _isLoading = true;
    if (_dashboard == null) {
      _state = HomeState.loading;
      notifyListeners();
    }
     _error = null;
    try {
      _location ??= await _locationSvc.getCurrentLocation();
      final loc = _location!;
      final results = await Future.wait(
          [
        _weatherSvc.fetch(
          lat: loc.lat,
          lon: loc.lon,
        ),
        _quakeSvc.fetchNearby(
          lat: loc.lat,
          lon: loc.lon,
          radiusKm: 250,
        ),
        _floodSvc.fetch(
          lat: loc.lat,
          lon: loc.lon,
        ),
      ]);
      final weather = results[0] as WeatherModel;
      final quakes = results[1] as List<EarthquakeModel>;
      final flood = results[2] as FloodModel;
      /// Calculate Risk
      final risk = RiskCalculator.calculate(
        weather: weather,
        nearbyQuakes: quakes,
        flood: flood,
      );
      /// Update dashboard
      _dashboard = DashboardModel(
        latitude: loc.lat,
        longitude: loc.lon,
        location: loc.location,
        weather: weather,
        nearbyEarthquakes: quakes,
        flood: flood,
        overallRisk: risk,
        lastUpdated: DateTime.now(),
      );
      _state = HomeState.loaded;
    } catch (e) {
      _error = _friendlyError(e);
      if (_dashboard == null) {
        _state = HomeState.error;
      }
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    await loadDashboard();
    _isRefreshing = false;
    notifyListeners();
  }


  String _friendlyError(Object error) {
    if (error is FetchDataException) {
      return 'No internet connection or server error.';
    }
    if (error is BadRequestException) {
      return 'Invalid request.';
    }
    if (error is UnauthorizedException) {
      return 'You are not authorized to access this data.';
    }
    if (error is InvalidInputException) {
      return 'Invalid input.';
    }
    if (error.toString().contains('denied')) {
      return 'Location permission required. Allow in Settings.';
    }
    return 'Could not load data. Tap refresh to retry.';
  }
}