import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class WatchAdminUsersUseCase {
  WatchAdminUsersUseCase(this._repository);

  final AdminUserRepository _repository;

  Stream<List<AdminUserEntity>> execute() {
    return _repository.watchUsers();
  }
}
