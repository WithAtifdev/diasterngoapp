
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService);


  bool loading = false;
  UserModel? user;


  // bool isLoggedIn() {
  //   return _authService.currentUser != null;
  // }



  Future<void> signIn(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      user = await _authService.signIn(email,password);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
  Future<void> signUp(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      user = await _authService.signUp(
        email,
        password,
      );
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    loading = true;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}