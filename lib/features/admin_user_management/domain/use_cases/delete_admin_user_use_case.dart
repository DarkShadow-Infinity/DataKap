import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class DeleteAdminUserUseCase {
  DeleteAdminUserUseCase(this._repository);

  final AdminUserRepository _repository;

  Future<void> execute(String id) {
    return _repository.deleteUser(id);
  }
}
