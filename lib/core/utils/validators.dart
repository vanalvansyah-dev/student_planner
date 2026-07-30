import 'package:flutter/material.dart';

/// Validator form Login & Register. Pesan selalu Bahasa Indonesia dan
/// menyebut apa yang harus diperbaiki (RULES.md §6).
class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email tidak boleh kosong';
    if (!_emailRegex.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password tidak boleh kosong';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? username(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username tidak boleh kosong';
    if (v.length < 3) return 'Username minimal 3 karakter';
    return null;
  }

  static String? Function(String?) confirmPassword(
    TextEditingController passwordController,
  ) {
    return (value) {
      if (value != passwordController.text) return 'Konfirmasi password tidak cocok';
      return null;
    };
  }
}