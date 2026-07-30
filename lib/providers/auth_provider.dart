import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/utils/firebase_error_mapper.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository) {
    _authSub = _repository.authStateChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<String?>? _authSub;

  bool _isInitializing = true;
  String? _uid;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isRegistering = false;

  bool get isInitializing => _isInitializing;
  bool get isLoggedIn => _uid != null;
  String? get uid => _uid;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _onAuthChanged(String? uid) async {
    if (_isRegistering) return;

    _uid = uid;
    _isInitializing = false;

    if (uid == null) {
      _userModel = null;
      notifyListeners();
      return;
    }

    notifyListeners();
    try {
      _userModel = await _repository.fetchUserProfile(uid);
    } catch (_) {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) {
    return _runAuthAction(() async {
      _isRegistering = true;
      try {
        await _repository.register(username: username, email: email, password: password);
      } finally {
        _isRegistering = false;
      }
    });
  }

  Future<bool> login({required String email, required String password}) {
    return _runAuthAction(() => _repository.login(email: email, password: password));
  }

  Future<void> logout() => _repository.logout();

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return _runAuthAction(() => _repository.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ));
  }

  Future<bool> updateProfile({required String username, required int colorIndex}) {
    return _runAuthAction(() async {
      await _repository.updateProfile(username: username, colorIndex: colorIndex);
      _userModel = _userModel?.copyWith(username: username, colorIndex: colorIndex);
    });
  }

  /// Selalu sukses dari sisi UI kecuali format email salah — lihat catatan
  /// anti-enumeration di FirebaseAuthRepository.sendPasswordResetEmail.
  Future<bool> sendPasswordResetEmail(String email) {
    return _runAuthAction(() => _repository.sendPasswordResetEmail(email));
  }

  Future<bool> _runAuthAction(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      _isLoading = false;
      notifyListeners();
      return true;
    } on AppAuthException catch (e) {
      _isLoading = false;
      _errorMessage = mapAuthError(e.code);
      notifyListeners();
      return false;
    } catch (_) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan. Coba lagi.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}