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

  RegistrationModel copyWith({
    String? id,
    String? role,
    bool? requiresPhoto,
    Map<String, dynamic>? fields,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? syncStatus,
    String? clientRequestId,
    String? syncError,
  }) {
    return RegistrationModel(
      id: id ?? this.id,
      role: role ?? this.role,
      requiresPhoto: requiresPhoto ?? this.requiresPhoto,
      fields: fields ?? this.fields,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      clientRequestId: clientRequestId ?? this.clientRequestId,
      syncError: syncError ?? this.syncError,
    );
  }
}
