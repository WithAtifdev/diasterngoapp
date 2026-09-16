
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';
import 'package:flutter/foundation.dart';
import '../services/ngo_service.dart';

enum RegisterState { idle, loading, success, error }

class NGORegisterViewModel extends ChangeNotifier {
  final NGOService _service;

  NGORegisterViewModel({required this._service});

  // ── State ──────────────────────────────────────────────────────────────────
  RegisterState _state = RegisterState.idle;
  String _errorMessage = '';
  NGOCategory _selectedCategory = NGOCategory.rescue;

  RegisterState get state => _state;
  String get errorMessage => _errorMessage;
  NGOCategory get selectedCategory => _selectedCategory;

  // ── Actions ────────────────────────────────────────────────────────────────
  void selectCategory(NGOCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<bool> submit({
    required String name,
    required String location,
    required String phone,
    required String email,
    required String description,
    required String imageUrl,
    required String easypaisa,
    required String jazzcash,
    required String bankTransfer,
  }) async {
    _state = RegisterState.loading;
    notifyListeners();

    try {
      final ngo = NGOModel(
        id: '',
        name: name,
        category: _selectedCategory,
        location: location,
        phone: phone,
        email: email,
        description: description,
        status: NGOStatus.pending,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        easypaisa: easypaisa,
        jazzcash: jazzcash,
        bankTransfer: bankTransfer,

      );
      await _service.registerNGO(ngo);
      _state = RegisterState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = RegisterState.error;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = RegisterState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}