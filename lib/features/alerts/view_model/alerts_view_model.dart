
import 'dart:async';
import 'package:diaster_ngo_app/features/alerts/model/alert_model.dart';
import 'package:flutter/material.dart';

import '../services/alert_service.dart';

class AlertsViewModel extends ChangeNotifier {
  final AlertService _alertService;

  AlertsViewModel(this._alertService);

  List<AlertModel> _officialAlerts = [];
  List<AlertModel> _liveAlerts = [];
  bool _isLoadingLive = false;
  bool _initialized = false;
  String? _error;
  StreamSubscription? _firestoreSub;
  List<AlertModel> get officialAlerts => _officialAlerts;
  List<AlertModel> get liveAlerts => _liveAlerts;
  bool get isLoadingLive => _isLoadingLive;
  String? get error => _error;

  /// =========================
  /// MERGED ALERTS
  /// =========================
  List<AlertModel> get allAlerts {
    final merged = [..._officialAlerts, ..._liveAlerts];
    merged.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return merged;
  }

  /// =========================
  /// HIGH PRIORITY
  /// =========================
  List<AlertModel> get highPriorityAlerts =>
      allAlerts.where((a) {
        return a.severity == AlertSeverity.extreme ||
            a.severity == AlertSeverity.high;
      }).toList();
  /// =========================
  /// INITIALIZE
  /// =========================
  void initialize() {
    if (_initialized) return;
    _initialized = true;
    _subscribeToFirestore();
    // Load in background
    Future.microtask(() {
      fetchLiveAlerts();
    });
  }

  /// =========================
  /// FIRESTORE REALTIME
  /// =========================
  void _subscribeToFirestore() {
    _firestoreSub =
        _alertService.officialAlertStream().listen(
              (data) {
            _officialAlerts = data;

            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();

            notifyListeners();
          },
        );
  }

  /// =========================
  /// LIVE ALERTS
  /// =========================
  Future<void> fetchLiveAlerts() async {
    // Prevent multiple refresh calls
    if (_isLoadingLive) return;

    _isLoadingLive = true;

    // ADD THIS
    notifyListeners();

    // old data will stay visible

    try {
      final newAlerts =
      await _alertService.fetchLiveAlerts();

      // Update ONLY when new data arrives
      _liveAlerts = newAlerts;

    } catch (e) {
      _error = e.toString();
    }

    _isLoadingLive = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _firestoreSub?.cancel();

    super.dispose();
  }
}