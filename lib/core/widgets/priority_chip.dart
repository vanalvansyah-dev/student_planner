import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});
  final String priority; // low | medium | high

  static const _labels = {'low': 'Rendah', 'medium': 'Sedang', 'high': 'Tinggi'};

  @override
  Widget build(BuildContext context) {
    final color = AppColors.priorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
      child: Text(
        _labels[priority] ?? priority,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}