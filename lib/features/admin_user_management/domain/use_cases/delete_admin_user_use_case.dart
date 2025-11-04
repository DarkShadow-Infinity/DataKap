import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class DeleteAdminUserUseCase {
  final AdminUserRepository repository;

  DeleteAdminUserUseCase(this.repository);

  Future<void> execute(String id) async {
    final result = await repository.deleteUser(id);
    result.fold(
      (failure) => throw ServerException(failure.message),
      (_) => null, // Success, do nothing
    );
  }
}
