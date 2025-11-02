import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/registration/data/data_sources/registration_local_data_source.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_sync_result_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_sync_summary_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;
  final RegistrationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RegistrationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RegistrationEntity>> createRegistration(RegistrationEntity registration) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRegistration = await remoteDataSource.createRegistration(registration as RegistrationModel);
        return Right(remoteRegistration);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<RegistrationEntity>>> getRegistrations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRegistrations = await remoteDataSource.getRegistrations();
        return Right(remoteRegistrations);
      } on ServerException catch (e) {
        return Left(ServerFailure(message:e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, RegistrationEntity>> getRegistration(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRegistration = await remoteDataSource.getRegistration(id);
        return Right(remoteRegistration);
      } on ServerException catch (e) {
        return Left(ServerFailure(message:e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, RegistrationEntity>> updateRegistration(RegistrationEntity registration) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRegistration = await remoteDataSource.updateRegistration(registration as RegistrationModel);
        return Right(remoteRegistration);
      } on ServerException catch (e) {
        return Left(ServerFailure(message:e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRegistration(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteRegistration(id);
        return Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message:e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<RegistrationSyncResultEntity>>> syncRegistrations(List<RegistrationEntity> registrations) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResults = await remoteDataSource.syncRegistrations(registrations.cast<RegistrationModel>());
        return Right(remoteResults);
      } on ServerException catch (e) {
        return Left(ServerFailure(message:e.message));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message:e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, List<RegistrationEntity>>> getPending() async {
    try {
      final localRegistrations = await localDataSource.getPending();
      return Right(localRegistrations);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<RegistrationEntity>>> getPendingRegistrations() async {
    try {
      final localRegistrations = await localDataSource.getPending();
      return Right(localRegistrations);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, RegistrationSyncSummaryEntity>> getSyncSummary() async {
    try {
      final localSummary = await remoteDataSource.getSyncSummary();
      return Right(localSummary);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
