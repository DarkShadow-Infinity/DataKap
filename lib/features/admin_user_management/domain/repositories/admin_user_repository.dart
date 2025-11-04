import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';

abstract class AdminUserRepository {
  Future<Either<Failure, AdminUserEntity>> getUser(String id);
  Stream<Either<Failure, List<AdminUserEntity>>> watchUsers();
  Future<Either<Failure, void>> createUser(AdminUserEntity entity);
  Future<Either<Failure, void>> updateUser(AdminUserEntity entity);
  Future<Either<Failure, void>> deleteUser(String id);
}
