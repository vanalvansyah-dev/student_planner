import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../providers/task_provider.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key, required this.value, required this.onChanged});
  final TaskFilter value;
  final ValueChanged<TaskFilter> onChanged;

  static const _labels = {TaskFilter.all: 'Semua', TaskFilter.pending: 'Belum', TaskFilter.done: 'Selesai'};

  @override
  Widget build(BuildContext context) {
    return Row(
      children: TaskFilter.values.map((f) {
        final selected = f == value;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(_labels[f]!),
            selected: selected,
            onSelected: (_) => onChanged(f),
            labelStyle: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }).toList(),
    );
  }
}