import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Stream<UserEntity> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: 'Error al leer la caché de usuario.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    if (!await networkInfo.isConnected) {
      return Left(ServerFailure(message: 'Sin conexión a internet. No se puede iniciar sesión.'));
    }

    try {
      final userModel = await remoteDataSource.signIn(email, password);
      return Right(userModel);
    } on ServerException catch (e) {
      debugPrint('ServerException during login: ${e.message}');
      return Left(AuthFailure(message: e.message));
    } catch (e) {
      debugPrint('Unknown error during login: $e');
      return Left(ServerFailure(message: 'Ocurrió un error inesperado al iniciar sesión.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Ocurrió un error inesperado durante el cierre de sesión: $e'));
    }
  }
}
