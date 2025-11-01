import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';

class AdminUserEntity {
  AdminUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.goal,
    required this.verificationCode,
    required this.status,
    required this.isActive,
    required this.createdAt,
  });

  factory AdminUserEntity.fromModel(AdminUserModel model) => AdminUserEntity(
        id: model.id,
        email: model.email,
        fullName: model.fullName,
        phone: model.phone,
        role: model.role,
        goal: model.goal,
        verificationCode: model.verificationCode,
        status: model.status,
        isActive: model.isActive,
        createdAt: model.createdAt,
      );

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final int goal;
  final String verificationCode;
  final String status;
  final bool isActive;
  final DateTime createdAt;

  AdminUserModel toModel() {
    return AdminUserModel(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      role: role,
      goal: goal,
      verificationCode: verificationCode,
      status: status,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
