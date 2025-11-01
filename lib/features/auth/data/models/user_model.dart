import 'package:datakap/features/auth/domain/entities/user_entity.dart';

// El modelo extiende la Entity, añadiendo métodos de mapeo de/a la Data Source.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Mapeo del rol de String a UserRole (la lógica de negocio)
    final roleString = json['role'] as String? ?? 'unknown';
    final role = _parseRole(roleString);

    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      role: role,
    );
  }

  // Mapea un User de Firebase a un UserRole interno
  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'recabador':
        return UserRole.recabador;
      default:
        return UserRole.unknown;
    }
  }

  // Mapea un objeto Firebase User (si existe)
  static UserModel? fromFirebaseUser(dynamic user, Map<String, dynamic>? userData) {
    if (user == null || userData == null) {
      return null;
    }

    return UserModel.fromJson({
      'uid': user.uid,
      'email': user.email ?? '',
      'role': userData['role'] ?? 'unknown',
    });
  }
}
