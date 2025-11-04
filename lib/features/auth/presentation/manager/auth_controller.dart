import 'package:datakap/core/app_routes.dart'; // Importa el nuevo archivo de rutas
import 'package:get/get.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final currentUser = UserEntity.empty.obs;
  final isLoading = false.obs;
  final isInitialCheckDone = false.obs;
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
    _listenToAuthState();
  }

  Future<void> _initializeAuth() async {
    final result = await _authRepository.getCachedUser();
    result.fold(
      (failure) {
        currentUser.value = UserEntity.empty;
      },
      (user) {
        currentUser.value = user ?? UserEntity.empty;
      },
    );
    isInitialCheckDone.value = true;
  }

  void _listenToAuthState() {
    _authRepository.authStateChanges.listen((user) {
      currentUser.value = user;

      if (user.isNotEmpty) {
        _redirectToHome(user.role);
      } else {
        if (isInitialCheckDone.value) {
          Get.offAllNamed(AppRoutes.login);
        }
      }
    });
  }

  Future<String?> login(String email, String password) async {
    isLoading.value = true;
    final result = await _authRepository.login(email, password);
    isLoading.value = false;

    return result.fold(
      (failure) {
        return failure.props.isNotEmpty ? failure.props[0] as String : 'Error desconocido';
      },
      (user) {
        return null;
      },
    );
  }

  Future<void> logout() async {
    final result = await _authRepository.logout();
    result.fold(
      (failure) {
        Get.snackbar(
          'Error', 
          failure.props.isNotEmpty ? failure.props[0] as String : 'Error al cerrar sesión',
          snackPosition: SnackPosition.BOTTOM
        );
      },
      (_) {},
    );
  }

  void _redirectToHome(UserRole role) {
    String route;
    switch (role) {
      case UserRole.admin:
        route = AppRoutes.homeAdmin;
        break;
      case UserRole.promoter:
        route = AppRoutes.homePromoter;
        break;
      case UserRole.leader:
        route = AppRoutes.homeLeader;
        break;
      default:
        route = AppRoutes.login;
        break;
    }
    Get.offAllNamed(route);
  }
}
