import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class GetRegistrationsUseCase {
  final RegistrationRepository repository;

  GetRegistrationsUseCase(this.repository);

  Future<Either<Failure, List<RegistrationEntity>>> call() async {
    return await repository.getRegistrations();
  }
}
