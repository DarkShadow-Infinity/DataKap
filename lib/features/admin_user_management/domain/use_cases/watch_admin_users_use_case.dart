import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class WatchAdminUsersUseCase {
  final AdminUserRepository repository;

  WatchAdminUsersUseCase(this.repository);

  Stream<List<AdminUserEntity>> execute() {
    return repository.watchUsers().map(
          (either) => either.fold(
            (failure) => [], // On failure, return an empty list for the stream
            (users) => users,
          ),
        );
  }
}
