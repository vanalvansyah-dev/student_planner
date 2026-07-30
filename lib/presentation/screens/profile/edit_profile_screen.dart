import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late int _colorIndex;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().userModel;
    _usernameController = TextEditingController(text: user?.username ?? '');
    _colorIndex = user?.colorIndex ?? 0;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      username: _usernameController.text,
      colorIndex: _colorIndex,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil diperbarui.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Gagal menyimpan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          children: [
            Center(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(gradient: AppColors.gradientForIndex(_colorIndex), shape: BoxShape.circle),
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Username',
              hint: 'cth. vanpratama',
              controller: _usernameController,
              validator: Validators.username,
            ),
            const SizedBox(height: 24),
            Text('Pilih Warna', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('6 pertama solid, 6 berikutnya gradasi', style: AppTextStyles.caption),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: List.generate(AppColors.profileColorOptions.length, (i) {
                final selected = i == _colorIndex;
                return GestureDetector(
                  onTap: () => setState(() => _colorIndex = i),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientForIndex(i),
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: AppColors.textPrimary, width: 3) : null,
                    ),
                    child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 20) : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            AppButton(label: 'Simpan Perubahan', isLoading: _isSubmitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}