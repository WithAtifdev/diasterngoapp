
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService);

  bool loading = false;
  UserModel? user;
  String? errorMessage;

  Future<void> signIn(String email, String password) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _authService.signIn(email, password);
    } catch (e) {
      errorMessage = _getErrorMessage(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _authService.signUp(
        email,
        password,
      );
    } catch (e) {
      errorMessage = _getErrorMessage(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
    } catch (e) {
      errorMessage = _getErrorMessage(e);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
          return 'Invalid email or password.';

        case 'user-not-found':
          return 'No account found with this email.';

        case 'email-already-in-use':
          return 'This email is already registered.';

        case 'weak-password':
          return 'Password is too weak.';

        case 'invalid-email':
          return 'Please enter a valid email.';

        case 'wrong-password':
          return 'Incorrect password.';

        default:
          return 'Something went wrong. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
