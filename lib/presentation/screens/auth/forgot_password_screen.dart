import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.sendPasswordResetEmail(_emailController.text);

    if (!mounted) return;

    if (success) {
      setState(() => _emailSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Gagal mengirim link. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
          child: _emailSent ? _buildSuccess() : _buildForm(isLoading),
        ),
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Lupa Password', style: AppTextStyles.pageTitle.copyWith(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            'Masukkan email akunmu. Kami akan mengirim link untuk membuat password baru.',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 28),
          AppTextField(
            label: 'Email',
            hint: 'nama@kampus.ac.id',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Kirim Link Reset', isLoading: isLoading, onPressed: _submit),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
            child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: 16),
          Text('Cek emailmu', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          Text(
            'Kalau email tersebut terdaftar, link reset password sudah dikirim. '
            'Periksa juga folder Spam kalau belum kelihatan.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          AppButton(label: 'Kembali ke Masuk', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}