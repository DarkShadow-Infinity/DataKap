import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.phone,
    required super.role,
    required super.goal,
    required super.verificationCode,
    required super.status,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory AdminUserModel.fromEntity(AdminUserEntity entity) {
    return AdminUserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      role: entity.role,
      goal: entity.goal,
      verificationCode: entity.verificationCode,
      status: entity.status,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory AdminUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AdminUserModel(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phone: data['phone'] ?? '',
      role: data['role'] ?? '',
      goal: data['goal'] ?? 0,
      verificationCode: data['verificationCode'] ?? '',
      status: data['status'] ?? 'pending',
      isActive: data['isActive'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'goal': goal,
      'verificationCode': verificationCode,
      'status': status,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
