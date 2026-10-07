
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/alerts/services/alert_service.dart';
import '../features/alerts/view_model/alerts_view_model.dart';

import '../features/auth/services/auth_service.dart';
import '../features/auth/view_model/auth_view_model.dart';

import '../features/home/services/earthquake_service.dart';
import '../features/home/services/flood_service.dart';
import '../features/home/services/location_service.dart';
import '../features/home/services/weather_service.dart';
import '../features/home/view_model/home_view_model.dart';

import '../features/ngos/services/ngo_service.dart';
import '../features/ngos/view_model/ngo_register_view_model.dart';
import '../features/ngos/view_model/ngo_view_model.dart';

import '../features/profile/services/profile_service.dart';
import '../features/profile/view_model/profile_view_model.dart';

final List<SingleChildWidget> appProviders = [
  // =========================
  // SERVICES
  // =========================

  Provider(
    create: (_) => AuthService(),
  ),

  Provider(
    create: (_) => LocationService(),
  ),

  Provider(
    create: (_) => WeatherService(),
  ),

  Provider(
    create: (_) => EarthquakeService(),
  ),

  Provider(
    create: (_) => FloodService(),
  ),

  Provider(
    create: (_) => AlertService(),
  ),

  Provider(
    create: (_) => NGOService(),
  ),

  Provider(
    create: (_) => ProfileService(),
  ),

  // =========================
  // VIEW MODELS
  // =========================

  ChangeNotifierProvider(
    create: (context) => AuthViewModel(
      context.read<AuthService>(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => HomeViewModel(
      context.read<WeatherService>(),
      context.read<EarthquakeService>(),
      context.read<FloodService>(),
      context.read<LocationService>(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => AlertsViewModel(
      context.read<AlertService>(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => NGOViewModel(
      context.read<NGOService>(),
    ),
  ),

  ChangeNotifierProvider(
    create: (context) => NGORegisterViewModel(
      service: context.read<NGOService>(),
    ),
  ),

  ChangeNotifierProxyProvider<AuthViewModel, ProfileViewModel>(
    create: (context) => ProfileViewModel(
      service: context.read<ProfileService>(),
    ),

    update: (context, authVm, previous) {
      if (previous == null) {
        return ProfileViewModel(
          service: context.read<ProfileService>(),
        );
      }

      previous.updateAuth(authVm);

      return previous;
    },
  ),
];