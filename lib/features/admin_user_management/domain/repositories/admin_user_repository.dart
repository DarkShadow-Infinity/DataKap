import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';

abstract class AdminUserRepository {
  Future<AdminUserEntity> getData(String id);
  Stream<List<AdminUserEntity>> watchUsers();
  Future<void> createUser(AdminUserEntity entity);
  Future<void> updateUser(AdminUserEntity entity);
  Future<void> deleteUser(String id);
}
