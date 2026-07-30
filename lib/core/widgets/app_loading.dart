import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Indikator loading reusable — dipakai AuthGate saat menunggu status auth awal.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 32});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
      ),
    );
  }
}