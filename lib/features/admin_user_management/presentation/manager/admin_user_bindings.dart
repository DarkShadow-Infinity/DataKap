import 'package:datakap/features/admin_user_management/data/data_sources/admin_user_remote_data_source.dart';
import 'package:datakap/features/admin_user_management/data/repositories/admin_user_repository_impl.dart';
import 'package:datakap/features/admin_user_management/domain/repositories/admin_user_repository.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/create_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/delete_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/get_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/update_admin_user_use_case.dart';
import 'package:datakap/features/admin_user_management/domain/use_cases/watch_admin_users_use_case.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:get/get.dart';

class AdminUserBindings extends Bindings {
  @override
  void dependencies() {
    // --- Data Sources ---
    Get.lazyPut<AdminUserRemoteDataSource>(
      () => AdminUserRemoteDataSourceImpl(firestore: Get.find()),
      fenix: true,
    );

    // --- Repositories ---
    Get.lazyPut<AdminUserRepository>(
      () => AdminUserRepositoryImpl(remoteDataSource: Get.find(), networkInfo: Get.find()),
      fenix: true,
    );

    // --- Use Cases ---
    Get.lazyPut(() => GetAdminUserUseCase(Get.find()));
    Get.lazyPut(() => WatchAdminUsersUseCase(Get.find()));
    Get.lazyPut(() => CreateAdminUserUseCase(Get.find()));
    Get.lazyPut(() => UpdateAdminUserUseCase(Get.find()));
    Get.lazyPut(() => DeleteAdminUserUseCase(Get.find()));

    // --- Controller ---
    Get.lazyPut(
      () => AdminUserController(
        getAdminUserUseCase: Get.find(),
        watchAdminUsersUseCase: Get.find(),
        createAdminUserUseCase: Get.find(),
        updateAdminUserUseCase: Get.find(),
        deleteAdminUserUseCase: Get.find(),
      ),
    );
  }
}
