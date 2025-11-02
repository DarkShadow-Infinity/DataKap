import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class GetRegistrationByIdUseCase {
  final RegistrationRepository repository;

  GetRegistrationByIdUseCase(this.repository);

  Future<Either<Failure, RegistrationEntity>> call(String id) async {
    return await repository.getRegistration(id);
  }
}
