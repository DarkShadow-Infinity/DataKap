// Este es el cerebro de la autenticación.
// Gestiona el estado reactivo del usuario y llama al Repositorio.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/app.dart'; // Para las rutas
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  // El usuario actual logueado. Es reactivo (Obx lo escucha).
  final currentUser = UserEntity.empty.obs;

  // Estado para la UI de Login (indicador de carga)
  final isLoading = false.obs;

  // Bandera para saber si ya se completó la verificación inicial de Firebase
  final isInitialCheckDone = false.obs;

  final AuthRepository _authRepository;

  // Track whether we already redirected to a home route for the current session
  bool _hasNavigatedToHome = false;
  UserRole? _lastHomeRole;

  // El repositorio se inyecta gracias al AppBindings
  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    // Iniciar la escucha del estado de autenticación de Firebase
    _listenToAuthState();
  }

  // Escucha el Stream del Repositorio para actualizar el estado del usuario
  void _listenToAuthState() {
    // Escuchamos el stream y actualizamos el estado reactivo
    _authRepository.authStateChanges.listen((user) {
      currentUser.value = user;

      // La primera vez que recibimos un estado, marcamos la verificación como completada
      if (!isInitialCheckDone.value) {
        isInitialCheckDone.value = true;
      }

      // Lógica de navegación principal (redundante con AuthWrapper, pero útil para Get.toNamed)
      if (user.isNotEmpty) {
        final shouldRedirect =
            !_hasNavigatedToHome || _lastHomeRole != user.role;
        if (shouldRedirect) {
          _redirectToHome(user.role);
        }
      } else {
        _hasNavigatedToHome = false;
        _lastHomeRole = null;
        // Solo redirigir a login si ya se hizo el chequeo inicial
        if (isInitialCheckDone.value) {
          Get.offAllNamed(AppRoutes.login);
        }
      }
    });
  }

  // Inicia sesión llamando al Repositorio
  Future<String?> login(String email, String password) async {
    isLoading.value = true;

    final result = await _authRepository.login(email, password);
    isLoading.value = false;

    // Manejo de la respuesta usando Dartz (Either)
    return result.fold(
          (failure) {
        // Retorna el mensaje de error para mostrar en la UI
        return failure.props[0] as String;
      },
          (user) {
        // Guardamos el usuario inmediatamente y navegamos sin esperar el stream.
        if (user.isNotEmpty) {
          currentUser.value = user;
          _redirectToHome(user.role);
        }

        return null; // No hay error
      },
    );
  }

  // Cierra sesión
  Future<void> logout() async {
    final result = await _authRepository.logout();

    result.fold(
            (failure) {
          // Aquí podrías mostrar un error si el cierre de sesión falla (poco común)
          Get.snackbar(
              'Error',
              'No se pudo cerrar la sesión: ${failure.props[0]}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white
          );
        },
            (_) {
          // El stream se encarga de mandar a la pantalla de Login
          // No necesitamos navegación explícita aquí.
        }
    );
  }

  // Función privada para manejar la redirección
  void _redirectToHome(UserRole role) {
    String route;
    if (role == UserRole.admin) {
      route = AppRoutes.homeAdmin;
    } else if (role == UserRole.promoter) {
      route = AppRoutes.homePromoter;
    } else if (role == UserRole.leader) {
      route = AppRoutes.homeLeader;
    } else {
      // Si el rol es desconocido, por seguridad volvemos a Login
      route = AppRoutes.login;
    }
    // Usamos offAllNamed para eliminar todas las rutas anteriores y no permitir el back
    Get.offAllNamed(route);
    _hasNavigatedToHome = true;
    _lastHomeRole = role;
  }
}
