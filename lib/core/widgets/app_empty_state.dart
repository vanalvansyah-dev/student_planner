import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                    child: Icon(icon, size: 32, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 6),
                  Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
                  if (actionLabel != null && onAction != null) ...[
                    const SizedBox(height: 20),
                    SizedBox(width: 200, child: AppButton(label: actionLabel!, onPressed: onAction)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}