import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    required this.taskId,
    required this.userId,
    required this.title,
    required this.course,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.status,
    this.createdAt,
  });

  final String taskId;
  final String userId;
  final String title;
  final String course;
  final String description;
  final String priority; // low | medium | high
  final DateTime deadline;
  final String status; // pending | done
  final DateTime? createdAt;

  bool get isDone => status == 'done';

  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return TaskModel(
      taskId: doc.id,
      userId: d['userId'] as String? ?? '',
      title: d['title'] as String? ?? '',
      course: d['course'] as String? ?? '',
      description: d['description'] as String? ?? '',
      priority: d['priority'] as String? ?? 'low',
      deadline: (d['deadline'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: d['status'] as String? ?? 'pending',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Dipakai saat create() — termasuk createdAt (serverTimestamp).
  Map<String, dynamic> toFirestore() => {
        ...toUpdateMap(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  /// Dipakai saat update() — TANPA createdAt, supaya tanggal pembuatan
  /// asli tidak tertimpa setiap kali tugas diedit.
  Map<String, dynamic> toUpdateMap() => {
        'userId': userId,
        'title': title.trim(),
        'course': course.trim(),
        'description': description.trim(),
        'priority': priority,
        'deadline': Timestamp.fromDate(deadline),
        'status': status,
      };

  TaskModel copyWith({
    String? title,
    String? course,
    String? description,
    String? priority,
    DateTime? deadline,
    String? status,
  }) {
    return TaskModel(
      taskId: taskId,
      userId: userId,
      title: title ?? this.title,
      course: course ?? this.course,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}