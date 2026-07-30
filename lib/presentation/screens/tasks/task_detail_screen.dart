import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/countdown_chip.dart';
import '../../../core/widgets/priority_chip.dart';
import '../../../data/models/task_model.dart';
import '../../../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});
  final TaskModel task;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus tugas ini?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      await context.read<TaskProvider>().deleteTask(task.taskId);
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas dihapus.')));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus tugas. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().allTasks;
    final current = tasks.firstWhere((t) => t.taskId == task.taskId, orElse: () => task);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskFormScreen(task: current))),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(current.title, style: AppTextStyles.pageTitle.copyWith(fontSize: 22)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.menu_book_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(current.course, style: AppTextStyles.caption),
                  ]),
                ),
                PriorityChip(priority: current.priority),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (current.isDone ? AppColors.primary : AppColors.accentAmber).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    current.isDone ? 'Selesai' : 'Belum Selesai',
                    style: AppTextStyles.caption.copyWith(
                      color: current.isDone ? AppColors.primaryDark : const Color(0xFFB45309),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                    child: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deadline', style: AppTextStyles.caption),
                        const SizedBox(height: 2),
                        Text(DateFormatter.shortWithTime(current.deadline), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  CountdownChip(deadline: current.deadline, isDone: current.isDone),
                ],
              ),
            ),
            if (current.description.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Deskripsi', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(current.description, style: AppTextStyles.bodySecondary.copyWith(height: 1.5)),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppTheme.screenPadding),
        child: AppButton(
          label: current.isDone ? 'Tandai Belum Selesai' : 'Tandai Selesai',
          icon: current.isDone ? Icons.replay_rounded : Icons.check_rounded,
          onPressed: () => context.read<TaskProvider>().toggleStatus(current),
        ),
      ),
    );
  }
}