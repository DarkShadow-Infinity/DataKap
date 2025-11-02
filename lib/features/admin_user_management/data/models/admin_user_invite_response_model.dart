import 'package:datakap/features/admin_user_management/domain/entities/admin_user_invite_response_entity.dart';

class AdminUserInviteResponseModel extends AdminUserInviteResponseEntity {
  const AdminUserInviteResponseModel({
    required super.id,
    required super.temporaryPassword,
    required super.verificationCode,
    required super.expiresAt,
  });

  factory AdminUserInviteResponseModel.fromJson(Map<String, dynamic> json) {
    return AdminUserInviteResponseModel(
      id: json['id'] as String,
      temporaryPassword: json['temporaryPassword'] as String,
      verificationCode: json['verificationCode'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temporaryPassword': temporaryPassword,
      'verificationCode': verificationCode,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
