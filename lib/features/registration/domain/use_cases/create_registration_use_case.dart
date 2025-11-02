import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class CreateRegistrationUseCase {
  final RegistrationRepository repository;

  CreateRegistrationUseCase(this.repository);

  Future<Either<Failure, RegistrationEntity>> call(
      RegistrationEntity registration) async {
    return await repository.createRegistration(registration);
  }
}
