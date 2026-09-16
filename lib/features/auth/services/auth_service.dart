import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// SIGN IN
  Future<UserModel> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user!;
    return UserModel.fromFirebase(user);
  }


  /// SIGN UP
  Future<UserModel> signUp(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user!;
    return UserModel.fromFirebase(user);
  }

  /// RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// CURRENT USER
  User? get currentUser => _auth.currentUser;
}