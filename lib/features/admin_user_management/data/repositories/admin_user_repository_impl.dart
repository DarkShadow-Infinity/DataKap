import 'package:datakap/features/admin_user_management/data/data_sources/admin_user_api.dart';
import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class AdminUserRepositoryImpl extends AdminUserRepository {
  AdminUserRepositoryImpl(this._api);

  final AdminUserApi _api;

  @override
  Future<AdminUserEntity> getData(String id) async {
    final model = await _api.fetchData(id);
    return model.toEntity();
  }

  @override
  Stream<List<AdminUserEntity>> watchUsers() {
    return _api.watchUsers().map(
          (models) =>
              models.map((model) => model.toEntity()).toList(growable: false),
        );
  }

  @override
  Future<void> createUser(AdminUserEntity entity) {
    return _api.createUser(AdminUserModel.fromEntity(entity));
  }

  @override
  Future<void> updateUser(AdminUserEntity entity) {
    return _api.updateUser(AdminUserModel.fromEntity(entity));
  }

  @override
  Future<void> deleteUser(String id) {
    return _api.deleteUser(id);
  }
}
