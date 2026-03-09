import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/demo_config.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  emailNotVerified,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.uninitialized;
  User? _user;
  UserModel? _userProfile;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get user => _user;
  UserModel? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  AuthProvider() {
    if (DEMO_MODE) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authService.authStateChanges.listen(_onAuthStateChanged);
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = AuthStatus.unauthenticated;
      _user = null;
      _userProfile = null;
    } else {
      _user = firebaseUser;
      await _authService.reloadUser();
      _user = _authService.currentUser;

      if (_user?.emailVerified == true) {
        _status = AuthStatus.authenticated;
        await _loadUserProfile();
      } else {
        _status = AuthStatus.emailNotVerified;
      }
    }
    notifyListeners();
  }

  Future<void> _loadUserProfile() async {
    if (_user != null) {
      _userProfile = await _authService.getUserProfile(_user!.uid);
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (DEMO_MODE) {
        await Future.delayed(const Duration(seconds: 1));
        _userProfile = UserModel(
          uid: 'demo-user-id',
          email: email,
          displayName: displayName,
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        _status = AuthStatus.authenticated;
      } else {
        await _authService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (DEMO_MODE) {
        await Future.delayed(const Duration(seconds: 1));
        _userProfile = UserModel(
          uid: 'demo-user-id',
          email: email,
          displayName: DEMO_USER_NAME,
          emailVerified: true,
          createdAt: DateTime.now(),
        );
        _status = AuthStatus.authenticated;
      } else {
        await _authService.signIn(email: email, password: password);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    if (DEMO_MODE) {
      _userProfile = null;
    } else {
      await _authService.signOut();
    }
    _status = AuthStatus.unauthenticated;
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  Future<bool> resendVerificationEmail() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resendVerificationEmail();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkEmailVerified() async {
    await _authService.reloadUser();
    _user = _authService.currentUser;

    if (_user?.emailVerified == true) {
      _status = AuthStatus.authenticated;
      await _loadUserProfile();
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
