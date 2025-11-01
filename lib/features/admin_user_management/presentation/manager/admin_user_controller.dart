import 'dart:async';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:datakap/core/presentation/so_notifier.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/create_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/delete_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/get_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/update_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/watch_admin_users_use_case.dart';

class AdminUserController extends SOGetXController {
  AdminUserController({
    required GetAdminUserUseCase getAdminUserUseCase,
    required WatchAdminUsersUseCase watchAdminUsersUseCase,
    required CreateAdminUserUseCase createAdminUserUseCase,
    required UpdateAdminUserUseCase updateAdminUserUseCase,
    required DeleteAdminUserUseCase deleteAdminUserUseCase,
  })  : _getAdminUserUseCase = getAdminUserUseCase,
        _watchAdminUsersUseCase = watchAdminUsersUseCase,
        _createAdminUserUseCase = createAdminUserUseCase,
        _updateAdminUserUseCase = updateAdminUserUseCase,
        _deleteAdminUserUseCase = deleteAdminUserUseCase;

  final GetAdminUserUseCase _getAdminUserUseCase;
  final WatchAdminUsersUseCase _watchAdminUsersUseCase;
  final CreateAdminUserUseCase _createAdminUserUseCase;
  final UpdateAdminUserUseCase _updateAdminUserUseCase;
  final DeleteAdminUserUseCase _deleteAdminUserUseCase;

  final RxList<AdminUserEntity> users = <AdminUserEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString filterRole = ''.obs;
  @override
  Rx<SONotifier?> uiNotifier = Rx<SONotifier?>(null);

  StreamSubscription<List<AdminUserEntity>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenToUsers();
  }

  void _listenToUsers() {
    isLoading.value = true;
    _subscription?.cancel();
    _subscription = _watchAdminUsersUseCase.execute().listen(
      (data) {
        users.assignAll(data);
        isLoading.value = false;
      },
      onError: (error, stack) {
        isLoading.value = false;
        uiNotifier.value = SONotifier(
          id: 'watch-error',
          type: SONotifierType.error,
          message: 'No se pudo cargar la lista de usuarios. Intenta nuevamente.',
        );
      },
    );
  }

  Future<void> fetchData(String id) async {
    if (id.isEmpty) {
      _listenToUsers();
      return;
    }
    try {
      isLoading.value = true;
      final entity = await _getAdminUserUseCase.execute(id);
      final index = users.indexWhere((element) => element.id == id);
      if (index >= 0) {
        users[index] = entity;
      } else {
        users.add(entity);
      }
    } catch (e) {
      uiNotifier.value = SONotifier(
        id: 'fetch-error',
        type: SONotifierType.error,
        message: 'No fue posible actualizar el usuario seleccionado.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createUser({
    required String email,
    required String fullName,
    required String phone,
    required String role,
    required int goal,
    required String verificationCode,
  }) async {
    final uid = const Uuid().v4();
    final entity = AdminUserEntity(
      id: uid,
      email: email,
      fullName: fullName,
      phone: phone,
      role: role,
      goal: goal,
      verificationCode: verificationCode,
      status: 'pending',
      isActive: false,
      createdAt: DateTime.now(),
    );

    try {
      await _createAdminUserUseCase.execute(entity);
      uiNotifier.value = const SONotifier(
        id: 'create-success',
        type: SONotifierType.success,
        message: 'Se registró la invitación correctamente.',
      );
      return true;
    } catch (e) {
      uiNotifier.value = const SONotifier(
        id: 'create-error',
        type: SONotifierType.error,
        message: 'No se pudo registrar al usuario. Revisa tu conexión e inténtalo de nuevo.',
      );
      return false;
    }
  }

  Future<void> toggleStatus(AdminUserEntity entity, String status) async {
    final updated = AdminUserEntity(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      phone: entity.phone,
      role: entity.role,
      goal: entity.goal,
      verificationCode: entity.verificationCode,
      status: status,
      isActive: status == 'registered',
      createdAt: entity.createdAt,
    );
    try {
      await _updateAdminUserUseCase.execute(updated);
      uiNotifier.value = SONotifier(
        id: 'update-success',
        type: SONotifierType.success,
        message: 'Se actualizó el estado del usuario.',
      );
    } catch (e) {
      uiNotifier.value = SONotifier(
        id: 'update-error',
        type: SONotifierType.error,
        message: 'No fue posible actualizar el estado. Intenta nuevamente.',
      );
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _deleteAdminUserUseCase.execute(id);
      uiNotifier.value = const SONotifier(
        id: 'delete-success',
        type: SONotifierType.success,
        message: 'Se eliminó el usuario de la lista.',
      );
    } catch (e) {
      uiNotifier.value = const SONotifier(
        id: 'delete-error',
        type: SONotifierType.error,
        message: 'No se pudo eliminar el registro.',
      );
    }
  }

  List<AdminUserEntity> get filteredUsers {
    final role = filterRole.value;
    if (role.isEmpty) {
      return users;
    }
    return users.where((element) => element.role == role).toList(growable: false);
  }

  int countByRole(String role, {String? status}) {
    return users.where((user) {
      if (user.role != role) return false;
      if (status == null) return true;
      return user.status == status;
    }).length;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
