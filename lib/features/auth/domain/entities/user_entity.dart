import 'package:equatable/equatable.dart';

// Define los roles posibles del usuario
enum UserRole {
  admin,
  recabador,
  unknown, // Usado para usuarios logueados sin rol o error
}

// Clase base para las propiedades inmutables del usuario
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
  });

  // Constructor factory para representar un usuario vacío/no logueado
  static const UserEntity empty = UserEntity(
    uid: '',
    email: '',
    role: UserRole.unknown,
  );

  // Getter para verificar si el usuario está vacío (no logueado)
  bool get isEmpty => uid.isEmpty;
  bool get isNotEmpty => uid.isNotEmpty;

  @override
  List<Object?> get props => [uid, email, role];

  @override
  String toString() => 'UserEntity(uid: $uid, email: $email, role: $role)';
}
