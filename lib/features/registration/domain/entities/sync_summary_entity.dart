import 'package:equatable/equatable.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';

class SyncSummaryEntity extends Equatable {
  const SyncSummaryEntity({
    required this.totalAttempted,
    required this.syncedCount,
    required this.failedCount,
    required this.pending,
  });

  final int totalAttempted;
  final int syncedCount;
  final int failedCount;
  final List<RegistrationEntity> pending;

  @override
  List<Object?> get props => [totalAttempted, syncedCount, failedCount, pending];
}
