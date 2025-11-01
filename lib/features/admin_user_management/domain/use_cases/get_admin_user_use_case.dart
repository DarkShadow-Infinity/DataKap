import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class GetAdminUserUseCase {
  GetAdminUserUseCase(this._repository);

  final AdminUserRepository _repository;

  Future<AdminUserEntity> execute(String id) {
    return _repository.getData(id);
  }
}
