import 'package:datakap/features/registration/domain/use_cases/registration_request.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class RegistrationEntity with EquatableMixin {
  final String id;
  final String role;
  final bool requiresPhoto;
  final Map<String, dynamic> fields;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String syncStatus;
  final String? clientRequestId;
  final String? syncError;

  const RegistrationEntity({
    required this.id,
    required this.role,
    required this.requiresPhoto,
    required this.fields,
    this.photoUrl,
    required this.createdAt,
    this.syncedAt,
    required this.syncStatus,
    this.clientRequestId,
    this.syncError,
  });

  factory RegistrationEntity.fromRequest(RegistrationRequest request) {
    final uuid = const Uuid();
    return RegistrationEntity(
      id: uuid.v4(),
      role: request.role.name,
      requiresPhoto: request.requiresPhoto,
      fields: request.fields,
      photoUrl: request.photoPath,
      createdAt: DateTime.now(),
      syncStatus: 'pending',
    );
  }

  @override
  List<Object?> get props => [
        id,
        role,
        requiresPhoto,
        fields,
        photoUrl,
        createdAt,
        syncedAt,
        syncStatus,
        clientRequestId,
        syncError,
      ];

  @override
  String toString() =>
      'RegistrationEntity(id: $id, role: $role, requiresPhoto: $requiresPhoto, fields: $fields, photoUrl: $photoUrl, createdAt: $createdAt, syncedAt: $syncedAt, syncStatus: $syncStatus, clientRequestId: $clientRequestId, syncError: $syncError)';

  bool get isSynced => syncStatus == 'synced';
}