import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';

class AdminUserModel extends AdminUserEntity {
  const AdminUserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.phone,
    required super.role,
    super.goal,
    required super.status,
    super.verificationCode,
    required super.createdAt,
    required super.isActive,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      goal: json['goal'] as int?,
      status: json['status'] as String,
      verificationCode: json['verificationCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  factory AdminUserModel.fromEntity(AdminUserEntity entity) {
    return AdminUserModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      role: entity.role,
      goal: entity.goal,
      status: entity.status,
      verificationCode: entity.verificationCode,
      createdAt: entity.createdAt,
      isActive: entity.isActive,
    );
  }

  AdminUserEntity toEntity() {
    return AdminUserEntity(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      role: role,
      goal: goal,
      status: status,
      verificationCode: verificationCode,
      createdAt: createdAt,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'role': role,
      'goal': goal,
      'status': status,
      'verificationCode': verificationCode,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}