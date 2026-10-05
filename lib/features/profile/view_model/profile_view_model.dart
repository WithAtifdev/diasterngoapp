
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaster_ngo_app/features/auth/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../model/app_user_model.dart';
import '../services/profile_service.dart';
enum ProfileState { loading, loaded, saving, error, loggedOut }
class ProfileViewModel extends ChangeNotifier {
  final ProfileService _service;

  ProfileViewModel({ProfileService? service})
      : _service = service ?? ProfileService() {
    loadUser();
  }

  void updateAuth(AuthViewModel authVm) {
    notifyListeners();
  }

  ProfileState _state = ProfileState.loading;
  AppUser? _user;
  String _errorMessage = '';

  ProfileState get state => _state;
  AppUser? get user => _user;
  String get errorMessage => _errorMessage;

  Future<void> loadUser() async {
    _state = ProfileState.loading;
    notifyListeners();

    try {
      _user = await _service.fetchCurrentUser();
      _state = ProfileState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProfileState.error;
    }

    notifyListeners();
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required UserRole role,
  }) async {
    if (_user == null) return false;

    _state = ProfileState.saving;
    notifyListeners();

    try {
      final updated = _user!.copyWith(name: name, email: email,role: role);
      await _service.updateProfile(updated);

      _user = updated;
      _state = ProfileState.loaded;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProfileState.error;
      notifyListeners();
      return false;
    }
  }
  Future<void> pickAndUploadProfileImage() async {
    try {
      final picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Firebase Storage path
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');

      await ref.putFile(file);

      final imageUrl = await ref.getDownloadURL();

      // Firestore update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({
        'photoUrl': imageUrl,
      });

      // local model update
      _user = _user?.copyWith(photoUrl: imageUrl);
      notifyListeners();
    } catch (e) {
      debugPrint('Image upload error: $e');
    }
  }
  Future<void> logout() async {
    await _service.signOut();
    _user = null;
    _state = ProfileState.loggedOut;
    notifyListeners();
  }
}
