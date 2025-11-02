import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class DeleteRegistrationUseCase {
  final RegistrationRepository repository;

  DeleteRegistrationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteRegistration(id);
  }
}
