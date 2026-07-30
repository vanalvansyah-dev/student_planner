import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/logo.png', width: 72, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text('Student Planner', style: AppTextStyles.pageTitle),
            const SizedBox(height: 4),
            Text('Versi 1.0.0', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 20),
            Text(
              'Aplikasi pengelola tugas kuliah dan deadline untuk mahasiswa. '
              'Setiap pengguna memiliki akun sendiri dan hanya dapat melihat data tugas miliknya.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),
            const SizedBox(height: 20),
            Text('Dibuat oleh Gilang Ilham Alvansyah', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}