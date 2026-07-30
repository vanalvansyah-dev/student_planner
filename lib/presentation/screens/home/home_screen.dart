import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/task_provider.dart';
import '../tasks/task_detail_screen.dart';
import 'widgets/stat_card.dart';
import 'widgets/upcoming_task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userModel;
    final colorIndex = user?.colorIndex ?? 0;
    final accentColors = AppColors.colorsForIndex(colorIndex);
    final tasks = context.watch<TaskProvider>();
    final upcoming = tasks.upcoming5;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                username: user?.username ?? '...',
                dueToday: tasks.dueTodayCount,
                dueTomorrow: tasks.dueTomorrowCount,
                colorIndex: colorIndex,
              ),
              Padding(
                padding: const EdgeInsets.all(AppTheme.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppTheme.gapBetweenCards,
                      crossAxisSpacing: AppTheme.gapBetweenCards,
                      childAspectRatio: 1.1,
                      children: [
                        StatCard(icon: Icons.checklist_rounded, value: '${tasks.totalTasks}', label: 'Total Tugas', gradientColors: accentColors),
                        StatCard(icon: Icons.schedule_rounded, value: '${tasks.dueTodayCount}', label: 'Deadline Hari Ini', gradientColors: accentColors),
                        StatCard(icon: Icons.check_circle_outline_rounded, value: '${tasks.completedCount}', label: 'Selesai', gradientColors: accentColors),
                        StatCard(icon: Icons.error_outline_rounded, value: '${tasks.pendingCount}', label: 'Belum Selesai', gradientColors: accentColors),
                      ],
                    ),
                    const SizedBox(height: AppTheme.gapBetweenSections),
                    Text('Deadline Terdekat', style: AppTextStyles.pageTitle.copyWith(fontSize: 18)),
                    const SizedBox(height: 12),
                    if (upcoming.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text('Tidak ada deadline dalam waktu dekat. Kerja bagus!', style: AppTextStyles.bodySecondary),
                      )
                    else
                      ...upcoming.map(
                        (t) => UpcomingTaskTile(
                          task: t,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t))),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.username,
    required this.dueToday,
    required this.dueTomorrow,
    required this.colorIndex,
  });

  final String username;
  final int dueToday;
  final int dueTomorrow;
  final int colorIndex;

  String get _warningText {
    if (dueToday == 0 && dueTomorrow == 0) {
      return 'Tidak ada tugas mendesak hari ini maupun besok. Kerja bagus!';
    }
    if (dueToday > 0 && dueTomorrow > 0) {
      return 'Ada $dueToday tugas yang harus selesai hari ini, dan $dueTomorrow tugas lagi besok.';
    }
    if (dueToday > 0) {
      return 'Ada $dueToday tugas yang harus selesai hari ini.';
    }
    return 'Tidak ada tugas mendesak hari ini, tapi ada $dueTomorrow tugas besok.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AppTheme.screenPadding, 24, AppTheme.screenPadding, 24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientForIndex(colorIndex),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Halo, $username 👋', style: AppTextStyles.pageTitle.copyWith(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 4),
          Text(DateFormatter.full(DateTime.now()), style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 10),
          Text(_warningText, style: AppTextStyles.body.copyWith(color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MiniStat(icon: Icons.today_rounded, count: dueToday, label: 'Hari Ini')),
              const SizedBox(width: 12),
              Expanded(child: _MiniStat(icon: Icons.event_rounded, count: dueTomorrow, label: 'Besok')),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.count, required this.label});
  final IconData icon;
  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$count', style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18)),
                Text(label, style: AppTextStyles.caption.copyWith(color: Colors.white.withValues(alpha: 0.85))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}