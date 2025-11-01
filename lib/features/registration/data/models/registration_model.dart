import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:hive/hive.dart';

part 'registration_model.g.dart';

@HiveType(typeId: 0)
class RegistrationModel {
  RegistrationModel({
    required this.id,
    required this.role,
    required this.requiresPhoto,
    required this.fields,
    this.photoPath,
    required this.createdAt,
    this.syncedAt,
    required this.isSynced,
    this.syncError,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final bool requiresPhoto;
  @HiveField(3)
  final Map<String, String> fields;
  @HiveField(4)
  final String? photoPath;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime? syncedAt;
  @HiveField(7)
  final bool isSynced;
  @HiveField(8)
  final String? syncError;

  RegistrationEntity toEntity() {
    return RegistrationEntity(
      id: id,
      role: _parseRole(role),
      requiresPhoto: requiresPhoto,
      fields: fields,
      photoPath: photoPath,
      createdAt: createdAt,
      syncedAt: syncedAt,
      isSynced: isSynced,
      syncError: syncError,
    );
  }

  RegistrationModel copyWith({
    bool? isSynced,
    DateTime? syncedAt,
    String? syncError,
  }) {
    return RegistrationModel(
      id: id,
      role: role,
      requiresPhoto: requiresPhoto,
      fields: fields,
      photoPath: photoPath,
      createdAt: createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
      syncError: syncError,
    );
  }

  static RegistrationModel fromEntity(RegistrationEntity entity) {
    return RegistrationModel(
      id: entity.id,
      role: entity.role.name,
      requiresPhoto: entity.requiresPhoto,
      fields: entity.fields,
      photoPath: entity.photoPath,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      isSynced: entity.isSynced,
      syncError: entity.syncError,
    );
  }

  static String _roleToString(UserRole role) {
    return role.name;
  }

  static UserRole _parseRole(String value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'promoter':
        return UserRole.promoter;
      case 'leader':
        return UserRole.leader;
      default:
        return UserRole.unknown;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'requiresPhoto': requiresPhoto,
      'fields': fields,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'isSynced': isSynced,
      'syncError': syncError,
    };
  }

  static RegistrationModel fromRequest({
    required String id,
    required UserRole role,
    required Map<String, String> fields,
    required bool requiresPhoto,
    String? photoPath,
  }) {
    return RegistrationModel(
      id: id,
      role: _roleToString(role),
      requiresPhoto: requiresPhoto,
      fields: fields,
      photoPath: photoPath,
      createdAt: DateTime.now(),
      syncedAt: null,
      isSynced: false,
      syncError: null,
    );
  }
}
