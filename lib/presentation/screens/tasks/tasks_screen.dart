import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../providers/task_provider.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import 'widgets/search_field.dart';
import 'widgets/task_card.dart';
import 'widgets/task_filter_chips.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.filteredTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Saya'),
        actions: [
          IconButton(
            icon: taskProvider.isRefreshing
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh_rounded),
            tooltip: 'Muat ulang',
            onPressed: taskProvider.isRefreshing ? null : () => taskProvider.refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskFormScreen())),
        child: const Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: 12),
            SearchField(initialValue: taskProvider.searchQuery, onChanged: context.read<TaskProvider>().setSearchQuery),
            const SizedBox(height: 12),
            TaskFilterChips(value: taskProvider.filter, onChanged: context.read<TaskProvider>().setFilter),
            const SizedBox(height: 12),
            Expanded(
              child: taskProvider.hasError
                  ? AppEmptyState(
                      icon: Icons.wifi_off_rounded,
                      title: 'Gagal memuat tugas',
                      message: taskProvider.lastError ?? 'Periksa koneksi internetmu, lalu coba lagi.',
                      actionLabel: 'Coba Lagi',
                      onAction: () => taskProvider.refresh(),
                    )
                  : tasks.isEmpty
                      ? AppEmptyState(
                          icon: Icons.checklist_rounded,
                          title: taskProvider.searchQuery.isEmpty ? 'Belum ada tugas' : 'Tidak ada tugas yang cocok',
                          message: taskProvider.searchQuery.isEmpty
                              ? 'Tambahkan tugas pertamamu supaya tidak ada deadline yang terlewat.'
                              : 'Coba kata kunci lain.',
                          actionLabel: taskProvider.searchQuery.isEmpty ? 'Tambah Tugas' : null,
                          onAction: taskProvider.searchQuery.isEmpty
                              ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskFormScreen()))
                              : null,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 88),
                          itemCount: tasks.length,
                          itemBuilder: (context, i) {
                            final task = tasks[i];
                            return TaskCard(
                              task: task,
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task))),
                              onToggleDone: () => context.read<TaskProvider>().toggleStatus(task),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}