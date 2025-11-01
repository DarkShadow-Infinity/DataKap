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
      case 'promovido':
      case 'promotor':
        return UserRole.promoter;
      case 'lider':
      case 'líder':
      case 'lideres':
      case 'líderes':
        return UserRole.leader;
      default:
        return UserRole.unknown;
    }
  }

  // Mapea un objeto Firebase User (si existe)
  static UserModel? fromFirebaseUser(dynamic user, Map<String, dynamic>? userData) {
    if (user == null) {
      return null;
    }

    final fallbackRole = userData?['role'] as String? ?? 'promovido';

    return UserModel.fromJson({
      'uid': user.uid,
      'email': user.email ?? '',
      'role': fallbackRole,
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'role': role.name,
    };
  }
}
