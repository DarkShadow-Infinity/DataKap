import 'package:equatable/equatable.dart';

// Define los roles posibles del usuario
enum UserRole {
  admin,
  promoter,
  leader,
  unknown, // Usado para usuarios logueados sin rol o error
}

// Clase base para las propiedades inmutables del usuario
class UserEntity extends Equatable {
  final String uid;
  final String email;
  final UserRole role;
  final String? fullName; // Add fullName
  final String? phone; // Add phone

  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    this.fullName, // Make fullName optional
    this.phone, // Make phone optional
  });

  // Constructor factory para representar un usuario vacío/no logueado
  static const UserEntity empty = UserEntity(
    uid: '',
    email: '',
    role: UserRole.unknown,
    fullName: null, // Initialize fullName as null
    phone: null, // Initialize phone as null
  );

  // Getter para verificar si el usuario está vacío (no logueado)
  bool get isEmpty => uid.isEmpty;
  bool get isNotEmpty => uid.isNotEmpty;

  @override
  List<Object?> get props => [uid, email, role, fullName, phone]; // Update props

  @override
  String toString() => 'UserEntity(uid: $uid, email: $email, role: $role, fullName: $fullName, phone: $phone)';
}
