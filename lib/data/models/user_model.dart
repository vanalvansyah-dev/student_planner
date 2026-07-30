import 'package:cloud_firestore/cloud_firestore.dart';

/// Model untuk collection `users`. Struktur field inti: SCHEMA.md §1.
/// `colorIndex` = tambahan personalisasi (index ke AppColors.profileColorOptions,
/// disimpan sebagai int supaya data layer tidak perlu tahu soal tipe Color).
class UserModel {
  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.createdAt,
    this.colorIndex = 0,
  });

  final String uid;
  final String username;
  final String email;
  final DateTime? createdAt;
  final int colorIndex;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return UserModel(
      uid: doc.id,
      username: data['username'] as String? ?? 'Pengguna',
      email: data['email'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      colorIndex: data['colorIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'colorIndex': colorIndex,
      };

  UserModel copyWith({String? username, int? colorIndex}) => UserModel(
        uid: uid,
        username: username ?? this.username,
        email: email,
        createdAt: createdAt,
        colorIndex: colorIndex ?? this.colorIndex,
      );
}