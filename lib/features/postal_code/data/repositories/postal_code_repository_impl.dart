import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/postal_code/data/data_sources/postal_code_remote_data_source.dart';
import 'package:datakap/features/postal_code/domain/entities/postal_code_info_entity.dart';
import 'package:datakap/features/postal_code/domain/repositories/postal_code_repository.dart';

class PostalCodeRepositoryImpl implements PostalCodeRepository {
  final PostalCodeRemoteDataSource remoteDataSource;

  PostalCodeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PostalCodeInfoEntity>> getInfoByPostalCode(String postalCode) async {
    try {
      final result = await remoteDataSource.getInfoByPostalCode(postalCode);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
