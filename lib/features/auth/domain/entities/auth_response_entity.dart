import 'package:equatable/equatable.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

class AuthResponseEntity extends Equatable {
  final String token;
  final String? refreshToken;
  final int expiresIn;
  final UserEntity user;

  const AuthResponseEntity({
    required this.token,
    this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  @override
  List<Object?> get props => [token, refreshToken, expiresIn, user];

  @override
  String toString() => 'AuthResponseEntity(token: $token, refreshToken: $refreshToken, expiresIn: $expiresIn, user: $user)';
}
