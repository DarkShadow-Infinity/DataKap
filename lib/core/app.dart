// Este archivo maneja la inyección de dependencias (DI) y las rutas de GetX.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// -- Importación de Capa de Datos y Dominio --
// Asegúrate de que estas rutas coincidan con tu estructura
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

// -- Importación de Capa de Presentación (Vistas y Controlador) --
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/pages/login_page.dart';
import 'package:datakap/features/auth/presentation/pages/home_admin_page.dart';
import 'package:datakap/features/auth/presentation/pages/role_options_page.dart';
import 'package:datakap/features/auth/presentation/pages/ine_registration_page.dart';
import 'package:datakap/features/auth/presentation/pages/manual_registration_page.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_promoter_page.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_leader_page.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
import 'package:datakap/features/auth/presentation/manager/admin_user_form_controller.dart';


// ==========================================================
// 1. GESTIÓN DE DEPENDENCIAS (Inyección con GetX)
// ==========================================================
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ----------------------------------------------------------------
    // DEPENDENCIAS DE AUTENTICACIÓN
    // ----------------------------------------------------------------

    // Core de Firebase: Instancias de servicios
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance, fenix: true);

    // Data Source: Usa las instancias de Firebase
    Get.lazyPut<AuthRemoteDataSource>(
            () => AuthRemoteDataSourceImpl(
          auth: Get.find(),
          firestore: Get.find(),
        ),
        fenix: true
    );

    // Repository: Usa el DataSource y el Contrato
    Get.lazyPut<AuthRepository>(
            () => AuthRepositoryImpl(
          remoteDataSource: Get.find(),
        ),
        fenix: true
    );

    // Controller: Usa el Repository (la lógica de negocio)
    // Se usa 'permanent: true' para que el controlador persista toda la vida de la app
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
  }
}

// ==========================================================
// 2. GESTIÓN DE RUTAS
// ==========================================================
class AppRoutes {
  static const String initial = '/'; // La ruta inicial que manejará el AuthController
  static const String login = '/login';
  static const String homeAdmin = '/home/admin';
  static const String homePromoter = '/home/promoter';
  static const String homeLeader = '/home/leader';
  static const String ineRegistration = '/registration/ine';
  static const String manualRegistration = '/registration/manual';
  static const String adminAddPromoter = '/admin/promoters/add';
  static const String adminAddLeader = '/admin/leaders/add';
}

class AppPages {
  static final pages = [
    // La página inicial usa el 'binding' para inyectar todas las dependencias
    GetPage(
      name: AppRoutes.initial,
      page: () => const AuthWrapper(), // Usaremos un wrapper para redirigir
      binding: AppBindings(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: AppBindings(), // Aunque el AuthController es permanent, se usa por si se entra directo
    ),

    GetPage(
      name: AppRoutes.homeAdmin,
      page: () => const HomeAdminPage(),
    ),

    GetPage(
      name: AppRoutes.homePromoter,
      page: () => const RoleOptionsPage(role: UserRole.promoter),
    ),

    GetPage(
      name: AppRoutes.homeLeader,
      page: () => const RoleOptionsPage(role: UserRole.leader),
    ),

    GetPage(
      name: AppRoutes.ineRegistration,
      page: () => const IneRegistrationPage(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>?;
        final role = args?['role'] as UserRole? ?? UserRole.promoter;
        Get.put(IneRegistrationController(role: role));
      }),
    ),

    GetPage(
      name: AppRoutes.manualRegistration,
      page: () => const ManualRegistrationPage(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>?;
        final role = args?['role'] as UserRole? ?? UserRole.promoter;
        Get.put(ManualRegistrationController(role: role));
      }),
    ),

    GetPage(
      name: AppRoutes.adminAddPromoter,
      page: () => const AdminAddPromoterPage(),
      binding: BindingsBuilder(() {
        Get.put(AdminPromoterFormController());
      }),
    ),

    GetPage(
      name: AppRoutes.adminAddLeader,
      page: () => const AdminAddLeaderPage(),
      binding: BindingsBuilder(() {
        Get.put(AdminLeaderFormController());
      }),
    ),
  ];
}


// ==========================================================
// 3. WRAPPER DE AUTENTICACIÓN (Redirige al usuario)
// ==========================================================
// El AuthWrapper es la primera pantalla que se carga y su única misión
// es escuchar el estado de autenticación (AuthRepository.authStateChanges)
// y redirigir a la pantalla correcta.

class AuthWrapper extends GetView<AuthController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Obx escucha las variables reactivas del controlador
    return Obx(() {
      final user = controller.currentUser.value;

      // Mostrar indicador de carga mientras se verifica el estado
      if (user.isEmpty && !controller.isInitialCheckDone.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Si no hay usuario logueado o el rol es desconocido, ir a Login
      if (user.isEmpty || user.role == UserRole.unknown) {
        return const LoginPage();
      }

      // Redirigir según el rol
      if (user.role == UserRole.admin) {
        return const HomeAdminPage();
      } else if (user.role == UserRole.promoter) {
        return const RoleOptionsPage(role: UserRole.promoter);
      } else if (user.role == UserRole.leader) {
        return const RoleOptionsPage(role: UserRole.leader);
      }

      // Fallback (debería ser manejado por el chequeo de "isEmpty")
      return const LoginPage();
    });
  }
}
