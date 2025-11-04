import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/admin_user_management/data/data_sources/admin_user_remote_data_source.dart';
import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminUserRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Stream<Either<Failure, List<AdminUserEntity>>> watchUsers() {
    return remoteDataSource.watchUsers().map<Either<Failure, List<AdminUserEntity>>>(
          (users) => Right(users),
    )..handleError((error) {
      return Left(ServerFailure(message: 'Failed to watch users'));
    });
  }

  @override
  Future<Either<Failure, AdminUserEntity>> getUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUser(id);
        return Right(user);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to get user'));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> createUser(AdminUserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createUser(AdminUserModel.fromEntity(user));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to create user'));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(AdminUserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUser(AdminUserModel.fromEntity(user));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to update user'));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteUser(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: 'Failed to delete user'));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
