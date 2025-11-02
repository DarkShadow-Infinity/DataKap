import 'package:equatable/equatable.dart';

class RegistrationSyncSummaryEntity extends Equatable {
  final int pending;
  final int syncedToday;
  final int failed;

  const RegistrationSyncSummaryEntity({
    required this.pending,
    required this.syncedToday,
    required this.failed,
  });

  @override
  List<Object?> get props => [pending, syncedToday, failed];

  @override
  String toString() =>
      'RegistrationSyncSummaryEntity(pending: $pending, syncedToday: $syncedToday, failed: $failed)';
}
