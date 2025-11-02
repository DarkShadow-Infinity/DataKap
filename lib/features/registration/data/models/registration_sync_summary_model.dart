import 'package:datakap/features/registration/domain/entities/registration_sync_summary_entity.dart';

class RegistrationSyncSummaryModel extends RegistrationSyncSummaryEntity {
  const RegistrationSyncSummaryModel({
    required super.pending,
    required super.syncedToday,
    required super.failed,
  });

  factory RegistrationSyncSummaryModel.fromJson(Map<String, dynamic> json) {
    return RegistrationSyncSummaryModel(
      pending: json['pending'] as int,
      syncedToday: json['syncedToday'] as int,
      failed: json['failed'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'syncedToday': syncedToday,
      'failed': failed,
    };
  }
}
