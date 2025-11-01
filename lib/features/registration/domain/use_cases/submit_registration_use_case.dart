import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';
import 'package:datakap/features/registration/domain/use_cases/registration_request.dart';

class SubmitRegistrationUseCase {
  SubmitRegistrationUseCase(this._repository);

  final RegistrationRepository _repository;

  Future<Either<Failure, RegistrationEntity>> execute(
    RegistrationRequest request,
  ) {
    return _repository.submitRegistration(request);
  }
}
