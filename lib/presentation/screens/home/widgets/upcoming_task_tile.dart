import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/countdown_chip.dart';
import '../../../../data/models/task_model.dart';

class UpcomingTaskTile extends StatelessWidget {
  const UpcomingTaskTile({super.key, required this.task, required this.onTap});
  final TaskModel task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.title, style: AppTextStyles.cardTitle),
                            const SizedBox(height: 4),
                            Text(task.course, style: AppTextStyles.bodySecondary),
                          ],
                        ),
                      ),
                      CountdownChip(deadline: task.deadline, isDone: task.isDone),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}