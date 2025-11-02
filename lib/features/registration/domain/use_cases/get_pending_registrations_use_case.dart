import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class GetPendingRegistrationsUseCase {
  GetPendingRegistrationsUseCase(this._repository);

  final RegistrationRepository _repository;

  Future<Either<Failure, List<RegistrationEntity>>> call() {
    return _repository.getPendingRegistrations();
  }
}
