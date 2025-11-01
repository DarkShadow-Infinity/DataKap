import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class UpdateAdminUserUseCase {
  UpdateAdminUserUseCase(this._repository);

  final AdminUserRepository _repository;

  Future<void> execute(AdminUserEntity entity) {
    return _repository.updateUser(entity);
  }
}
