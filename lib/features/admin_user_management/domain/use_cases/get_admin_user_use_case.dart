import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class GetAdminUserUseCase {
  final AdminUserRepository repository;

  GetAdminUserUseCase(this.repository);

  Future<AdminUserEntity> execute(String id) async {
    final result = await repository.getUser(id);
    return result.fold(
      (failure) => throw ServerException(failure.message),
      (user) => user,
    );
  }
}
