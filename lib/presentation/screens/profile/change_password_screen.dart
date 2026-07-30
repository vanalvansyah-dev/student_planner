import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.changePassword(
      oldPassword: _oldController.text,
      newPassword: _newController.text,
    );

    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Gagal mengubah password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Ganti Password')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          children: [
            AppTextField(
              label: 'Password Lama',
              hint: '••••••••',
              controller: _oldController,
              obscureText: true,
              validator: (v) => (v == null || v.isEmpty) ? 'Password lama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password Baru',
              hint: '••••••••',
              controller: _newController,
              obscureText: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Konfirmasi Password Baru',
              hint: '••••••••',
              controller: _confirmController,
              obscureText: true,
              validator: Validators.confirmPassword(_newController),
            ),
            const SizedBox(height: 28),
            AppButton(label: 'Simpan Password', isLoading: isLoading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}