import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/entities/sync_summary_entity.dart';
import 'package:datakap/features/registration/domain/use_cases/registration_request.dart';

abstract class RegistrationRepository {
  Future<Either<Failure, RegistrationEntity>> submitRegistration(
    RegistrationRequest request,
  );

  Future<Either<Failure, List<RegistrationEntity>>> getPendingRegistrations();

  Future<Either<Failure, SyncSummaryEntity>> syncPendingRegistrations();
}
