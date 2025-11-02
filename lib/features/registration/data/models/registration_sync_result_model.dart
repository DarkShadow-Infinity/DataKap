import 'package:datakap/features/registration/domain/entities/registration_sync_result_entity.dart';

class RegistrationSyncResultModel extends RegistrationSyncResultEntity {
  const RegistrationSyncResultModel({
    required super.clientRequestId,
    required super.status,
    super.serverId,
  });

  factory RegistrationSyncResultModel.fromJson(Map<String, dynamic> json) {
    return RegistrationSyncResultModel(
      clientRequestId: json['clientRequestId'] as String,
      status: json['status'] as String,
      serverId: json['serverId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientRequestId': clientRequestId,
      'status': status,
      'serverId': serverId,
    };
  }
}
