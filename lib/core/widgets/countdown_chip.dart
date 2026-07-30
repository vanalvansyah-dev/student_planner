import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/date_formatter.dart';

/// Elemen tanda tangan aplikasi (DESIGN.md §5).
/// Mint = normal, Amber = hari ini, Merah = terlewat, Abu = sudah selesai.
class CountdownChip extends StatelessWidget {
  const CountdownChip({super.key, required this.deadline, required this.isDone});

  final DateTime deadline;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color bg;
    late final Color fg;

    if (isDone) {
      text = 'Selesai';
      bg = AppColors.border;
      fg = AppColors.textSecondary;
    } else if (DateFormatter.isOverdue(deadline, isDone: false)) {
      text = 'Terlewat';
      bg = AppColors.danger.withValues(alpha: 0.12);
      fg = AppColors.danger;
    } else if (DateFormatter.isToday(deadline)) {
      text = 'Hari ini';
      bg = AppColors.accentAmber.withValues(alpha: 0.18);
      fg = const Color(0xFFB45309);
    } else {
      text = DateFormatter.countdown(deadline);
      bg = AppColors.primaryContainer;
      fg = AppColors.primaryDark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}