import 'package:equatable/equatable.dart';

class AdminUserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phone;
  final String role;
  final int? goal;
  final String status;
  final String? verificationCode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const AdminUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    this.goal,
    required this.status,
    this.verificationCode,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phone,
        role,
        goal,
        status,
        verificationCode,
        createdAt,
        updatedAt,
        isActive,
      ];

  @override
  String toString() =>
      'AdminUserEntity(id: $id, email: $email, fullName: $fullName, phone: $phone, role: $role, goal: $goal, status: $status, verificationCode: $verificationCode, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
}