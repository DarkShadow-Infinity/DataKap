import 'dart:async';

import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/network/api_endpoint.dart';
import 'package:datakap/core/network/api_provider.dart';
import 'package:datakap/core/network/auth_interceptor.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/models/user_model.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:get/get.dart';

abstract class AuthRemoteDataSource {
  Stream<UserEntity> get authStateChanges;
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthLocalDataSource localDataSource;

  final StreamController<UserEntity> _authStateController = StreamController<UserEntity>.broadcast();

  AuthRemoteDataSourceImpl({required this.localDataSource});

  @override
  Stream<UserEntity> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await APIProvider.post(
      ApiEndPoint.logIn,
      data: {'email': email, 'password': password},
      useAuth: false, // El login no necesita enviar un token.
    ).request();

    if (response.success && response.data != null) {
      final tokenManager = Get.find<AuthTokenManager>();
      final String token = response.data['token'];
      await tokenManager.setToken(token);

      final userModel = UserModel.fromJson(response.data['user']);
      await localDataSource.cacheUser(userModel);

      _authStateController.add(userModel);
      return userModel;
    } else {
      throw ServerException(response.message);
    }
  }

  @override
  Future<void> signOut() async {
    await APIProvider.post(ApiEndPoint.logOut).request();

    final tokenManager = Get.find<AuthTokenManager>();
    await tokenManager.setToken('');
    await localDataSource.clearUser();
    
    _authStateController.add(UserEntity.empty);
  }
}
