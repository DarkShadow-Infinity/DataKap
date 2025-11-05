import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/postal_code/domain/entities/postal_code_info_entity.dart';
import 'package:datakap/features/postal_code/domain/repositories/postal_code_repository.dart';

class GetInfoByPostalCodeUseCase {
  final PostalCodeRepository repository;

  GetInfoByPostalCodeUseCase(this.repository);

  Future<Either<Failure, PostalCodeInfoEntity>> call(String postalCode) async {
    return await repository.getInfoByPostalCode(postalCode);
  }
}
