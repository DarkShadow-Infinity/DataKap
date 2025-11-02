import 'package:datakap/features/registration/domain/entities/registration_entity.dart';

class RegistrationModel extends RegistrationEntity {
  const RegistrationModel({
    required super.id,
    required super.role,
    required super.requiresPhoto,
    required super.fields,
    super.photoUrl,
    required super.createdAt,
    super.syncedAt,
    required super.syncStatus,
    super.clientRequestId,
    super.syncError,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      id: json['id'] as String,
      role: json['role'] as String,
      requiresPhoto: json['requiresPhoto'] as bool,
      fields: Map<String, dynamic>.from(json['fields'] as Map),
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
      syncStatus: json['syncStatus'] as String,
      clientRequestId: json['clientRequestId'] as String?,
      syncError: json['syncError'] as String?,
    );
  }

  factory RegistrationModel.fromEntity(RegistrationEntity entity) {
    return RegistrationModel(
      id: entity.id,
      role: entity.role,
      requiresPhoto: entity.requiresPhoto,
      fields: entity.fields,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      syncStatus: entity.syncStatus,
      clientRequestId: entity.clientRequestId,
      syncError: entity.syncError,
    );
  }

  RegistrationEntity toEntity() {
    return RegistrationEntity(
      id: id,
      role: role,
      requiresPhoto: requiresPhoto,
      fields: fields,
      photoUrl: photoUrl,
      createdAt: createdAt,
      syncedAt: syncedAt,
      syncStatus: syncStatus,
      clientRequestId: clientRequestId,
      syncError: syncError,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'requiresPhoto': requiresPhoto,
      'fields': fields,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'syncStatus': syncStatus,
      'clientRequestId': clientRequestId,
      'syncError': syncError,
    };
  }
}