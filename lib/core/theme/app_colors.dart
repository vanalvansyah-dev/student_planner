import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF16A34A);
  static const Color primaryDark = Color(0xFF14532D);
  static const Color primaryContainer = Color(0xFFDCFCE7);

  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);

  static const Color background = Color(0xFFF6F8F6);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0F1B14);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color priorityLow = Color(0xFF16A34A);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFDC2626);

  static Color priorityColor(String priority) {
    switch (priority) {
      case 'high':
        return priorityHigh;
      case 'medium':
        return priorityMedium;
      case 'low':
      default:
        return priorityLow;
    }
  }

  /// 12 pilihan warna aksen personal: index 0-5 solid, index 6-11 gradasi 2 warna.
  /// Dipakai avatar Profil, header Dashboard, dan ikon kartu statistik.
  static const List<List<Color>> profileColorOptions = [
    // --- 6 solid ---
    [Color(0xFF16A34A), Color(0xFF16A34A)], // Hijau
    [Color(0xFF2563EB), Color(0xFF2563EB)], // Biru
    [Color(0xFF7C3AED), Color(0xFF7C3AED)], // Ungu
    [Color(0xFFDB2777), Color(0xFFDB2777)], // Pink
    [Color(0xFFEA580C), Color(0xFFEA580C)], // Oranye
    [Color(0xFF475569), Color(0xFF475569)], // Abu Slate
    // --- 6 gradasi ---
    [Color(0xFFF97316), Color(0xFFEC4899)], // Sunset
    [Color(0xFF2563EB), Color(0xFF06B6D4)], // Ocean
    [Color(0xFF7C3AED), Color(0xFFEC4899)], // Dream
    [Color(0xFF16A34A), Color(0xFF0D9488)], // Forest
    [Color(0xFFDC2626), Color(0xFFF59E0B)], // Fire
    [Color(0xFF4338CA), Color(0xFF9333EA)], // Twilight
  ];

  static List<Color> colorsForIndex(int index) =>
      profileColorOptions[index.clamp(0, profileColorOptions.length - 1)];

  /// Warna representatif tunggal — dipakai kalau butuh 1 warna saja (mis. ikon kecil).
  static Color solidForIndex(int index) => colorsForIndex(index).first;

  static LinearGradient gradientForIndex(int index) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colorsForIndex(index),
      );
}