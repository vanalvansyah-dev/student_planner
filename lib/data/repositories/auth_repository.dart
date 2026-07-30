import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AppAuthException implements Exception {
  const AppAuthException(this.code);
  final String code;
}

abstract class AuthRepository {
  Stream<String?> get authStateChanges;

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> logout();

  Future<UserModel> fetchUserProfile(String uid);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> updateProfile({required String username, required int colorIndex});

  Future<void> sendPasswordResetEmail(String email);
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;
      final profile = UserModel(uid: uid, username: username.trim(), email: email.trim());
      await _firestore.collection('users').doc(uid).set(profile.toFirestore());
      await _auth.signOut();
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AppAuthException(e.code);
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw AppAuthException(e.code);
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<UserModel> fetchUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      final email = _auth.currentUser?.email ?? '';
      final fallback = UserModel(
        uid: uid,
        username: email.isNotEmpty ? email.split('@').first : 'Pengguna',
        email: email,
      );
      await _firestore.collection('users').doc(uid).set(fallback.toFirestore());
      return fallback;
    }

    return UserModel.fromFirestore(doc);
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AppAuthException('requires-recent-login');
    }
    try {
      final cred = EmailAuthProvider.credential(email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AppAuthException(e.code);
    }
  }

  @override
  Future<void> updateProfile({required String username, required int colorIndex}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw const AppAuthException('requires-recent-login');
    await _firestore.collection('users').doc(uid).update({
      'username': username.trim(),
      'colorIndex': colorIndex,
    });
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      // 'user-not-found' sengaja tidak dilempar sebagai error — mencegah
      // aplikasi dipakai untuk mengecek email mana saja yang terdaftar.
      if (e.code == 'user-not-found') return;
      throw AppAuthException(e.code);
    }
  }
}