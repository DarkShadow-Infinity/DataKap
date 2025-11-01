import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/sync_summary_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class SyncPendingRegistrationsUseCase {
  SyncPendingRegistrationsUseCase(this._repository);

  final RegistrationRepository _repository;

  Future<Either<Failure, SyncSummaryEntity>> execute() {
    return _repository.syncPendingRegistrations();
  }
}
