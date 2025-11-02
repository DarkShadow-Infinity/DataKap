import 'package:datakap/features/auth/domain/entities/user_entity.dart';

// El modelo extiende la Entity, añadiendo métodos de mapeo de/a la Data Source.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.role,
    super.fullName,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roleString = json['role'] as String? ?? 'unknown';
    final role = _parseRole(roleString);

    return UserModel(
      uid: json['id'] as String, // Use 'id' from API response
      email: json['email'] as String,
      role: role,
      fullName: json['fullName'] as String?, // Parse fullName
      phone: json['phone'] as String?, // Parse phone
    );
  }

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

  static UserModel? fromFirebaseUser(dynamic user, Map<String, dynamic>? userData) {
    if (user == null) {
      return null;
    }

    final fallbackRole = userData?['role'] as String? ?? 'promovido';

    return UserModel.fromJson({
      'id': user.uid, // Use 'id' for consistency with API
      'email': user.email ?? '',
      'role': fallbackRole,
      'fullName': userData?['fullName'] as String?, // Pass fullName from userData
      'phone': userData?['phone'] as String?, // Pass phone from userData
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid, // Use 'id' for consistency with API
      'email': email,
      'role': role.name,
      'fullName': fullName,
      'phone': phone,
    };
  }
}
