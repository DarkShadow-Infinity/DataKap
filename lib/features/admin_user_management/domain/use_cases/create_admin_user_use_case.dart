import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class CreateAdminUserUseCase {
  final AdminUserRepository repository;

  CreateAdminUserUseCase(this.repository);

  Future<void> execute(AdminUserEntity user) async {
    final result = await repository.createUser(user);
    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null, // Success, do nothing
    );
  }
}
