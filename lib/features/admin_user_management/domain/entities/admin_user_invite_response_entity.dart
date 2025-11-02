import 'package:equatable/equatable.dart';

class AdminUserInviteResponseEntity extends Equatable {
  final String id;
  final String temporaryPassword;
  final String verificationCode;
  final DateTime expiresAt;

  const AdminUserInviteResponseEntity({
    required this.id,
    required this.temporaryPassword,
    required this.verificationCode,
    required this.expiresAt,
  });

  @override
  List<Object?> get props =>
      [id, temporaryPassword, verificationCode, expiresAt];

  @override
  String toString() =>
      'AdminUserInviteResponseEntity(id: $id, temporaryPassword: $temporaryPassword, verificationCode: $verificationCode, expiresAt: $expiresAt)';
}
