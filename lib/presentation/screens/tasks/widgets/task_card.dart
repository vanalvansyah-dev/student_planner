import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/countdown_chip.dart';
import '../../../../core/widgets/priority_chip.dart';
import '../../../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap, required this.onToggleDone});
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleDone;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: task.isDone ? 0.6 : 1,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: AppColors.priorityColor(task.priority)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: AppTextStyles.cardTitle.copyWith(
                                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: onToggleDone,
                              child: Icon(
                                task.isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
                                color: task.isDone ? AppColors.primary : AppColors.border,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.menu_book_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(task.course, style: AppTextStyles.bodySecondary),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            PriorityChip(priority: task.priority),
                            const Spacer(),
                            CountdownChip(deadline: task.deadline, isDone: task.isDone),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}