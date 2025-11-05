import 'package:datakap/features/admin_user_management/data/models/admin_user_model.dart';
import 'package:dio/dio.dart';

abstract class AdminUserRemoteDataSource {
  Stream<List<AdminUserModel>> watchUsers();
  Future<AdminUserModel> getUser(String id);
  Future<void> createUser(AdminUserModel user);
  Future<void> updateUser(AdminUserModel user);
  Future<void> deleteUser(String id);
}

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final Dio dio;

  AdminUserRemoteDataSourceImpl({required this.dio});

  @override
  Stream<List<AdminUserModel>> watchUsers() {
    // This will need to be implemented with a WebSocket or similar
    // for real-time updates. For now, it returns an empty stream.
    return Stream.value([]);
  }

  @override
  Future<AdminUserModel> getUser(String id) async {
    final response = await dio.get('/users/$id');
    return AdminUserModel.fromJson(response.data);
  }

  @override
  Future<void> createUser(AdminUserModel user) async {
    await dio.post('/users', data: user.toJson());
  }

  @override
  Future<void> updateUser(AdminUserModel user) async {
    await dio.put('/users/${user.id}', data: user.toJson());
  }

  @override
  Future<void> deleteUser(String id) async {
    await dio.delete('/users/$id');
  }
}
