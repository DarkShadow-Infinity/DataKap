import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/postal_code/domain/entities/postal_code_info_entity.dart';

abstract class PostalCodeRepository {
  Future<Either<Failure, PostalCodeInfoEntity>> getInfoByPostalCode(String postalCode);
}
