import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/app_user_model.dart';


class ProfileService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String _collection = 'users';

  ProfileService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? get currentFirebaseUser => _auth.currentUser;

  /// Fetches the AppUser document from Firestore.
  /// Falls back to a mock user when offline / unauthenticated.
  Future<AppUser> fetchCurrentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return _mockUser();

    try {
      final doc =
      await _firestore.collection(_collection).doc(fbUser.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(fbUser.uid, doc.data()!);
      }
      // First login: create profile from Firebase Auth data
      final user = AppUser(
        uid: fbUser.uid,
        name: fbUser.displayName ?? 'User',
        email: fbUser.email ?? '',
        role: UserRole.volunteer,
        photoUrl: fbUser.photoURL,
      );
      await _firestore
          .collection(_collection)
          .doc(fbUser.uid)
          .set(user.toMap());
      return user;
    } catch (_) {
      return _mockUser();
    }
  }

  Future<void> updateProfile(AppUser user) async {
    await _firestore
        .collection(_collection)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AppUser _mockUser() => const AppUser(
    uid: 'mock_uid',
    name: 'Atif Khan',
    email: 'atif@gmail.com',
    role: UserRole.volunteer,
  );
}