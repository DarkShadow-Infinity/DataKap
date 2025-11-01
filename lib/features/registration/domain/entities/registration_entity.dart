import 'package:equatable/equatable.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

class RegistrationEntity extends Equatable {
  const RegistrationEntity({
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

  final String id;
  final UserRole role;
  final bool requiresPhoto;
  final Map<String, String> fields;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool isSynced;
  final String? syncError;

  RegistrationEntity copyWith({
    bool? isSynced,
    DateTime? syncedAt,
    String? syncError,
  }) {
    return RegistrationEntity(
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

  @override
  List<Object?> get props => [
        id,
        role,
        requiresPhoto,
        fields,
        photoPath,
        createdAt,
        syncedAt,
        isSynced,
        syncError,
      ];
}
