import 'package:datakap/features/auth/domain/entities/auth_response_entity.dart';
import 'package:datakap/features/auth/data/models/user_model.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.token,
    super.refreshToken,
    required super.expiresIn,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'user': (user as UserModel).toJson(),
    };
  }
}
