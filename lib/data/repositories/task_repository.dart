import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRepository {
  /// Live stream — sumber utama data.
  Stream<List<TaskModel>> watchTasks(String userId);

  /// Ambil data sekali lewat query biasa (bukan stream). Dipakai sebagai
  /// jaring pengaman: dipanggil ulang setelah tiap create/update/delete/toggle,
  /// dan lewat tombol refresh manual — supaya tetap sinkron walau live
  /// listener sedang bermasalah di jaringan tertentu.
  Future<List<TaskModel>> fetchTasksOnce(String userId);

  Future<void> create(TaskModel task);
  Future<void> update(TaskModel task);
  Future<void> delete(String taskId);
  Future<void> toggleStatus(String taskId, {required bool isDone});
}

class FirestoreTaskRepository implements TaskRepository {
  FirestoreTaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _tasks => _firestore.collection('tasks');

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return _tasks
        .where('userId', isEqualTo: userId)
        .orderBy('deadline')
        .snapshots()
        .map((snap) => snap.docs.map(TaskModel.fromFirestore).toList());
  }

  @override
  Future<List<TaskModel>> fetchTasksOnce(String userId) async {
    final snap = await _tasks.where('userId', isEqualTo: userId).orderBy('deadline').get();
    return snap.docs.map(TaskModel.fromFirestore).toList();
  }

  @override
  Future<void> create(TaskModel task) => _tasks.doc().set(task.toFirestore());

  @override
  Future<void> update(TaskModel task) => _tasks.doc(task.taskId).update(task.toUpdateMap());

  @override
  Future<void> delete(String taskId) => _tasks.doc(taskId).delete();

  @override
  Future<void> toggleStatus(String taskId, {required bool isDone}) =>
      _tasks.doc(taskId).update({'status': isDone ? 'done' : 'pending'});
}