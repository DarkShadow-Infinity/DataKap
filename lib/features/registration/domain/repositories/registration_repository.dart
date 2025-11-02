import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_sync_summary_entity.dart';

abstract class RegistrationRepository {
  Future<Either<Failure, RegistrationEntity>> createRegistration(RegistrationEntity registration);
  Future<Either<Failure, List<RegistrationEntity>>> getRegistrations();
  Future<Either<Failure, RegistrationEntity>> getRegistration(String id);
  Future<Either<Failure, RegistrationEntity>> updateRegistration(RegistrationEntity registration);
  Future<Either<Failure, void>> deleteRegistration(String id);
  Future<Either<Failure, RegistrationSyncSummaryEntity>> getSyncSummary();
  Future<Either<Failure, List<RegistrationEntity>>> getPendingRegistrations();
}
