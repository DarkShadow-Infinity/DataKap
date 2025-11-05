import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:datakap/core/network/auth_interceptor.dart';
import 'package:datakap/features/admin_user_management/data/data_sources/admin_user_remote_data_source.dart';
import 'package:datakap/features/admin_user_management/data/repositories/admin_user_repository_impl.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/create_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/delete_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/get_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/update_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/watch_admin_users_use_case.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/admin_user_management/presentation/pages/admin_user_management_page.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';
import 'package:datakap/features/auth/presentation/manager/admin_user_form_controller.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_leader_page.dart';
import 'package:datakap/features/auth/presentation/pages/admin_add_promoter_page.dart';
import 'package:datakap/features/auth/presentation/pages/home_admin_page.dart';
import 'package:datakap/features/auth/presentation/pages/ine_registration_page.dart';
import 'package:datakap/features/auth/presentation/pages/login_page.dart';
import 'package:datakap/features/auth/presentation/pages/manual_registration_page.dart';
import 'package:datakap/features/auth/presentation/pages/role_options_page.dart';
import 'package:datakap/features/registration/data/data_sources/registration_local_data_source.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source_impl.dart';
import 'package:datakap/features/registration/data/repositories/registration_repository_impl.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';
import 'package:datakap/features/registration/domain/use_cases/create_registration_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/delete_registration_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/get_pending_registrations_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/get_registration_by_id_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/get_registrations_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/submit_registration_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/sync_pending_registrations_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/update_registration_use_case.dart';
import 'package:datakap/features/registration/presentation/manager/registration_controller.dart';
import 'package:datakap/features/registration/presentation/manager/registration_sync_controller.dart';
import 'package:datakap/features/registration/presentation/pages/registration_page.dart';
import 'package:datakap/features/registration/presentation/pages/registration_sync_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'app_routes.dart';
import 'network/network_info.dart';
import 'network/network_info_impl.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthTokenManager>(() => AuthTokenManager(), fenix: true);
    // Register Dio globally
    Get.lazyPut<Dio>(() => Dio(), fenix: true);
    Get.lazyPut<Connectivity>(() => Connectivity(), fenix: true);
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()), fenix: true);
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(localDataSource: Get.find()),
      fenix: true,
    );
    Get.lazyPut<RegistrationLocalDataSource>(
      () => RegistrationLocalDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<RegistrationRemoteDataSource>(
      () => RegistrationRemoteDataSourceImpl(),
      fenix: true,
    );
    // Correctly inject Dio into AdminUserRemoteDataSourceImpl
    Get.lazyPut<AdminUserRemoteDataSource>(
      () => AdminUserRemoteDataSourceImpl(dio: Get.find<Dio>()),
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
    Get.lazyPut<RegistrationRepository>(
      () => RegistrationRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut<AdminUserRepository>(
      () => AdminUserRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => CreateAdminUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetAdminUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateAdminUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteAdminUserUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => WatchAdminUsersUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CreateRegistrationUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetRegistrationsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetRegistrationByIdUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateRegistrationUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteRegistrationUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPendingRegistrationsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SyncPendingRegistrationsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SubmitRegistrationUseCase(Get.find()), fenix: true);
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
  }
}

class AdminBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AdminUserController(
        watchAdminUsersUseCase: Get.find(),
        deleteAdminUserUseCase: Get.find(),
        updateAdminUserUseCase: Get.find(),
        createAdminUserUseCase: Get.find(),
        getAdminUserUseCase: Get.find(),
      ),
    );
  }
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.initial, page: () => const AuthWrapper()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(
      name: AppRoutes.homeAdmin,
      page: () => const HomeAdminPage(),
      binding: AdminBindings(),
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
        final role = Get.arguments?['role'] as UserRole? ?? UserRole.promoter;
        Get.lazyPut(
          () => IneRegistrationController(
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
        final role = Get.arguments?['role'] as UserRole? ?? UserRole.promoter;
        Get.lazyPut(
          () => ManualRegistrationController(
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
        Get.lazyPut(
          () => RegistrationSyncController(
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
      binding: AdminBindings(),
      fullscreenDialog: true,
    ),
    GetPage(
      name: AppRoutes.adminAddPromoter,
      page: () => const AdminAddPromoterPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminUserFormController>(
          () => AdminPromoterFormController(),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.adminAddLeader,
      page: () => const AdminAddLeaderPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminUserFormController>(() => AdminLeaderFormController());
      }),
    ),
    GetPage(
      name: AppRoutes.registrations,
      page: () => const RegistrationPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(
          () => RegistrationController(
            createRegistrationUseCase: Get.find(),
            getRegistrationsUseCase: Get.find(),
            getRegistrationByIdUseCase: Get.find(),
            updateRegistrationUseCase: Get.find(),
            deleteRegistrationUseCase: Get.find(),
          ),
        );
      }),
    ),
  ];
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Obx(() {
      if (!controller.isInitialCheckDone.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final user = controller.currentUser.value;
      final currentRoute = Get.currentRoute;
      String targetRoute;

      if (user.isEmpty || user.role == UserRole.unknown) {
        targetRoute = AppRoutes.login;
      } else {
        switch (user.role) {
          case UserRole.admin:
            targetRoute = AppRoutes.homeAdmin;
            break;
          case UserRole.promoter:
            targetRoute = AppRoutes.homePromoter;
            break;
          case UserRole.leader:
            targetRoute = AppRoutes.homeLeader;
            break;
          default:
            targetRoute = AppRoutes.login;
        }
      }

      if (currentRoute != targetRoute) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(targetRoute);
        });
      }

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    });
  }
}
