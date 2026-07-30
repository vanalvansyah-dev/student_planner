import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

enum TaskFilter { all, pending, done }

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repository);

  final TaskRepository _repository;
  StreamSubscription<List<TaskModel>>? _sub;

  List<TaskModel> _allTasks = [];
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  String? _uid;
  bool _hasError = false;
  String? _lastError;
  bool _isRefreshing = false;

  TaskFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  bool get hasError => _hasError;
  String? get lastError => _lastError;
  bool get isRefreshing => _isRefreshing;

  void bindUser(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _sub?.cancel();
    _allTasks = [];
    _hasError = false;

    if (uid == null) {
      notifyListeners();
      return;
    }

    _sub = _repository.watchTasks(uid).listen(
      (tasks) {
        _allTasks = tasks;
        _hasError = false;
        notifyListeners();
      },
      onError: (Object error) {
        debugPrint('TaskProvider stream error: $error');
        _hasError = true;
        _lastError = error.toString();
        notifyListeners();
      },
    );

    // Ambil data sekali juga di awal — tidak menunggu stream saja.
    refresh();
  }

  /// Ambil ulang data sekali (bukan lewat stream). Dipanggil otomatis
  /// setelah tiap aksi tulis berhasil, dan lewat tombol refresh manual.
  Future<void> refresh() async {
    if (_uid == null) return;
    _isRefreshing = true;
    notifyListeners();
    try {
      _allTasks = await _repository.fetchTasksOnce(_uid!);
      _hasError = false;
      _lastError = null;
    } catch (e) {
      debugPrint('TaskProvider refresh error: $e');
      _hasError = true;
      _lastError = e.toString();
    }
    _isRefreshing = false;
    notifyListeners();
  }

  List<TaskModel> get allTasks => List.unmodifiable(_allTasks);

  List<TaskModel> get filteredTasks {
    final q = _searchQuery.toLowerCase().trim();
    return _allTasks.where((t) {
      final cocokStatus = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.pending => t.status == 'pending',
        TaskFilter.done => t.status == 'done',
      };
      final cocokQuery =
          q.isEmpty || t.title.toLowerCase().contains(q) || t.course.toLowerCase().contains(q);
      return cocokStatus && cocokQuery;
    }).toList();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setFilter(TaskFilter value) {
    _filter = value;
    notifyListeners();
  }

  int get totalTasks => _allTasks.length;
  int get completedCount => _allTasks.where((t) => t.isDone).length;
  int get pendingCount => _allTasks.where((t) => !t.isDone).length;
  int get dueTodayCount => _allTasks.where((t) => !t.isDone && _isSameDay(t.deadline, 0)).length;
  int get dueTomorrowCount => _allTasks.where((t) => !t.isDone && _isSameDay(t.deadline, 1)).length;

  List<TaskModel> get upcoming5 {
    final pending = _allTasks.where((t) => !t.isDone).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return pending.take(5).toList();
  }

  bool _isSameDay(DateTime d, int daysFromNow) {
    final target = DateTime.now().add(Duration(days: daysFromNow));
    return d.year == target.year && d.month == target.month && d.day == target.day;
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.create(task);
    await refresh();
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.update(task);
    await refresh();
  }

  Future<void> deleteTask(String taskId) async {
    await _repository.delete(taskId);
    await refresh();
  }

  Future<void> toggleStatus(TaskModel task) async {
    await _repository.toggleStatus(task.taskId, isDone: !task.isDone);
    await refresh();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}