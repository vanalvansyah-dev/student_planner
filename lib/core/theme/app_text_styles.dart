import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Skala tipografi aplikasi.
/// Plus Jakarta Sans untuk judul & angka statistik, Inter untuk body & label.
/// Jangan panggil GoogleFonts langsung dari screen — selalu lewat kelas ini.
class AppTextStyles {
  AppTextStyles._();

  /// Angka besar di kartu statistik Dashboard (mis. "12").
  static TextStyle get displayStat => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.1,
      );

  /// Judul halaman (AppBar / heading utama).
  static TextStyle get pageTitle => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  /// Judul di dalam kartu tugas.
  static TextStyle get cardTitle => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  /// Teks isi biasa.
  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  /// Teks isi dengan penekanan lebih rendah (mis. nama mata kuliah di bawah judul).
  static TextStyle get bodySecondary => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  /// Label kecil, caption, teks di dalam chip.
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  /// Teks tombol utama.
  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.surface,
      );
}