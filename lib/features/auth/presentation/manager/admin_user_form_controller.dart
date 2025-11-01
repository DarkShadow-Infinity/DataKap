import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

abstract class AdminUserFormController extends GetxController {
  AdminUserFormController(this.role);

  final UserRole role;
  final formKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;
  final AdminUserController adminUserController = Get.find();

  late final TextEditingController emailController;
  late final TextEditingController tempPasswordController;
  late final TextEditingController fullNameController;
  late final TextEditingController phoneController;
  late final TextEditingController goalController;
  late final TextEditingController verificationCodeController;

  String get roleLabel => role == UserRole.leader ? 'líder' : 'promovido';

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    tempPasswordController = TextEditingController();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    goalController = TextEditingController();
    verificationCodeController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    tempPasswordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    goalController.dispose();
    verificationCodeController.dispose();
    super.onClose();
  }

  Future<void> submitForm() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    isSubmitting.value = true;
    final success = await adminUserController.createUser(
      email: emailController.text.trim(),
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      role: role == UserRole.leader ? 'leader' : 'promoter',
      goal: int.tryParse(goalController.text.trim()) ?? 0,
      verificationCode: verificationCodeController.text.trim(),
    );
    isSubmitting.value = false;

    if (success) {
      Get.snackbar(
        'Invitación enviada',
        'Se registró el ${roleLabel.toLowerCase()} correctamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: Colors.white,
      );

      emailController.clear();
      tempPasswordController.clear();
      fullNameController.clear();
      phoneController.clear();
      goalController.clear();
      verificationCodeController.clear();
    } else {
      Get.snackbar(
        'Error al registrar',
        'No se pudo crear la invitación, intenta nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: Colors.white,
      );
    }
  }
}

class AdminPromoterFormController extends AdminUserFormController {
  AdminPromoterFormController() : super(UserRole.promoter);
}

class AdminLeaderFormController extends AdminUserFormController {
  AdminLeaderFormController() : super(UserRole.leader);
}
