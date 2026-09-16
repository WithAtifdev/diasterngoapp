import 'dart:async';
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';
import 'package:flutter/foundation.dart';
import '../services/ngo_service.dart';

enum ViewState { idle, loading, success, error }

class NGOViewModel extends ChangeNotifier {
  final NGOService _service;

  NGOViewModel(NGOService service) : _service = service {
    _subscribe();
  }

  // ── State ──────────────────────────────────────────────────────────────────
  ViewState _state = ViewState.loading;
  String _errorMessage = '';
  List<NGOModel> _allNGOs = [];
  NGOCategory _selectedCategory = NGOCategory.all;
  String _searchQuery = '';
  StreamSubscription<List<NGOModel>>? _sub;

  // ── Public getters ─────────────────────────────────────────────────────────
  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  NGOCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<NGOModel> get filteredNGOs {
    return _allNGOs.where((ngo) {
      final matchesCategory = _selectedCategory == NGOCategory.all ||
          ngo.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          ngo.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ngo.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void selectCategory(NGOCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> registerNGO(NGOModel ngo) async {
    _setState(ViewState.loading);
    try {
      await _service.registerNGO(ngo);
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  // ── Private ────────────────────────────────────────────────────────────────
  void _subscribe() {
    _sub = _service.watchNGOs().listen(
          (ngos) {
        _allNGOs = ngos;
        _setState(ViewState.success);
      },
      onError: (e) {
        _errorMessage = e.toString();
        _setState(ViewState.error);
      },
    );
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}