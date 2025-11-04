import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datakap/core/network/auth_interceptor.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_bindings.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/admin_user_management/presentation/pages/admin_user_management_page.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/admin_user_form_controller.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_leader_page.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_promoter_page.dart';
import 'package:datakap/features/auth/presentation/pages/home_admin_page.dart';
import 'package:datakap/features/auth/presentation/pages/ine_registration_page.dart';
import 'package:datakap/features/auth/presentation/pages/login_page.dart';
import 'package:datakap/features/auth/presentation/pages/role_options_page.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';
import 'package:datakap/features/registration/presentation/manager/registration_controller.dart';
import 'package:datakap/features/registration/presentation/manager/registration_sync_controller.dart';
import 'package:datakap/features/registration/presentation/pages/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
import 'package:datakap/features/auth/presentation/pages/manual_registration_page.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source_impl.dart';
import 'package:datakap/features/registration/presentation/pages/registration_sync_page.dart';
import 'app_routes.dart';
import 'network/network_info.dart';
import 'network/network_info_impl.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';
import 'package:datakap/features/registration/data/data_sources/registration_local_data_source.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:datakap/features/auth/data/repositories/auth_repository_impl.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // --- SINGLETONS ---
    Get.lazyPut<AuthTokenManager>(() => AuthTokenManager(), fenix: true);
    // APIProvider ya no se inyecta. Se usa como una fábrica estática.

    // --- CORE ---
    Get.lazyPut<Connectivity>(() => Connectivity(), fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance, fenix: true);

    // --- AUTENTICACIÓN ---
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(), fenix: true);
    // AuthRemoteDataSourceImpl ya no necesita que se le inyecte el APIProvider.
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(localDataSource: Get.find()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);

    // --- REGISTROS ---
    Get.lazyPut<RegistrationLocalDataSource>(
      () => RegistrationLocalDataSourceImpl(),
      fenix: true,
    );
    // RegistrationRemoteDataSourceImpl ya no tiene dependencias en el constructor.
    Get.lazyPut<RegistrationRemoteDataSource>(
      () => RegistrationRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<RegistrationRepository>(
      () => RegistrationRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );
    // ... aquí el resto de dependencias que tenías
  }
}

// ==========================================================
// 2. GESTIÓN DE PÁGINAS
// ==========================================================
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const AuthWrapper(),
      binding: AppBindings(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: AppRoutes.homeAdmin,
      page: () => const HomeAdminPage(),
      binding: AdminUserBindings(),
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
        Get.put(
          IneRegistrationController(
            role: role,
            submitRegistrationUseCase: Get.find(),
            networkInfo: Get.find(),
          ),
        );
      }),
    ),

    GetPage(
      name: AppRoutes.manualRegistration,
      page: () => const ManualRegistrationPage(),
      binding: BindingsBuilder(() {
        final args = Get.arguments as Map<String, dynamic>?;
        final role = args?['role'] as UserRole? ?? UserRole.promoter;
        Get.put(
          ManualRegistrationController(
            role: role,
            submitRegistrationUseCase: Get.find(),
            networkInfo: Get.find(),
          ),
        );
      }),
    ),

    GetPage(
      name: AppRoutes.registrationSync,
      page: () => const RegistrationSyncPage(),
      binding: BindingsBuilder(() {
        Get.put(
          RegistrationSyncController(
            getPendingRegistrationsUseCase: Get.find(),
            syncPendingRegistrationsUseCase: Get.find(),
            networkInfo: Get.find(),
          ),
        );
      }),
    ),

    GetPage(
      name: AppRoutes.adminUserManagement,
      page: () => const AdminUserManagementPage(),
      binding: BindingsBuilder(() {
        Get.find<AdminUserController>();
      }),
      fullscreenDialog: true,
    ),

    GetPage(
      name: AppRoutes.adminAddPromoter,
      page: () => const AdminAddPromoterPage(),
      binding: BindingsBuilder(() {
        Get.put<AdminUserFormController>(AdminPromoterFormController());
      }),
    ),

    GetPage(
      name: AppRoutes.adminAddLeader,
      page: () => const AdminAddLeaderPage(),
      binding: BindingsBuilder(() {
        Get.put<AdminUserFormController>(AdminLeaderFormController());
      }),
    ),
    GetPage(
      name: AppRoutes.registrations,
      page: () => const RegistrationPage(),
      binding: BindingsBuilder(() {
        Get.put(RegistrationController(
          createRegistrationUseCase: Get.find(),
          getRegistrationsUseCase: Get.find(),
          getRegistrationByIdUseCase: Get.find(),
          updateRegistrationUseCase: Get.find(),
          deleteRegistrationUseCase: Get.find(),
        ));
      }),
    ),
  ];
}

// ==========================================================
// 3. WRAPPER DE AUTENTICACIÓN
// ==========================================================
class AuthWrapper extends GetView<AuthController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;

      if (user.isEmpty && !controller.isInitialCheckDone.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (user.isEmpty || user.role == UserRole.unknown) {
        return const LoginPage();
      }

      switch (user.role) {
        case UserRole.admin:
          return const HomeAdminPage();
        case UserRole.promoter:
          return const RoleOptionsPage(role: UserRole.promoter);
        case UserRole.leader:
          return const RoleOptionsPage(role: UserRole.leader);
        default:
          return const LoginPage();
      }
    });
  }
}
