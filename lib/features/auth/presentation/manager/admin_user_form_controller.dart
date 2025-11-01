import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

abstract class AdminUserFormController extends GetxController {
  AdminUserFormController(this.role);

  final UserRole role;
  final formKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;

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
    await Future.delayed(const Duration(milliseconds: 600));
    isSubmitting.value = false;

    Get.snackbar(
      'Usuario creado',
      'Se envió la invitación para el ${roleLabel.toLowerCase()}.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueGrey.shade700,
      colorText: Colors.white,
    );

    emailController.clear();
    tempPasswordController.clear();
    fullNameController.clear();
    phoneController.clear();
    goalController.clear();
    verificationCodeController.clear();
  }
}

class AdminPromoterFormController extends AdminUserFormController {
  AdminPromoterFormController() : super(UserRole.promoter);
}

class AdminLeaderFormController extends AdminUserFormController {
  AdminLeaderFormController() : super(UserRole.leader);
}
