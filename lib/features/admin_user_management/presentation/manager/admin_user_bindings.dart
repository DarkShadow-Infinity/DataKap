import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:get/get.dart';

class AdminUserBindings extends Bindings {
  @override
  void dependencies() {
    // Core dependencies are injected globally in AppBindings.
    // This binding is now only responsible for the AdminUserController.
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
