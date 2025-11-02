import 'package:equatable/equatable.dart';

class RegistrationSyncResultEntity extends Equatable {
  final String clientRequestId;
  final String status;
  final String? serverId;

  const RegistrationSyncResultEntity({
    required this.clientRequestId,
    required this.status,
    this.serverId,
  });

  @override
  List<Object?> get props => [clientRequestId, status, serverId];

  @override
  String toString() =>
      'RegistrationSyncResultEntity(clientRequestId: $clientRequestId, status: $status, serverId: $serverId)';
}
