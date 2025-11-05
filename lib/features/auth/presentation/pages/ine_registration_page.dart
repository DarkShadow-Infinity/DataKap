import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
import 'package:datakap/features/auth/presentation/pages/scanner/id_scanner_page.dart';
import 'package:datakap/features/auth/presentation/widgets/registration_form_fields.dart';

class IneRegistrationPage extends GetView<IneRegistrationController> {
  const IneRegistrationPage({super.key});

  String _roleLabel(UserRole role) =>
      role == UserRole.leader ? 'líder' : 'promovido';

  @override
  Widget build(BuildContext context) {
    final roleTitle =
        controller.role == UserRole.leader ? 'Líder' : 'Promovido';
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro INE - $roleTitle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary.withAlpha((255 * 0.12).round())),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Captura la credencial INE del ${_roleLabel(controller.role)} y verifica que la imagen sea legible.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.hasPhoto.value
                              ? AppColors.accent
                              : AppColors.secondary.withAlpha((255 * 0.3).round()),
                          width: 2,
                        ),
                        color: controller.hasPhoto.value
                            ? AppColors.accent.withAlpha((255 * 0.12).round())
                            : AppColors.background,
                      ),
                      child: Center(
                        child: controller.hasPhoto.value && controller.capturedImagePath.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14), // Match the container's border radius
                                child: Image.file(
                                  File(controller.capturedImagePath.value),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.credit_card, size: 48, color: AppColors.secondary),
                                  SizedBox(height: 12),
                                  Text('Aún no se ha capturado la credencial'),
                                ],
                              ),
                      ),
                    )),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Get.to(() => const IDScannerPage());
                    if (result != null && result is Map<String, dynamic>) {
                      controller.updateFormFromScan(result);
                    }
                  },
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: const Text('Scan INE with Camera'),
                ),
                const SizedBox(height: 32),
                Text(
                  'Completa los datos del ${_roleLabel(controller.role)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                RegistrationFormFields(controller: controller),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitForm,
                  icon: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(controller.isSubmitting.value
                      ? 'Enviando registro...'
                      : 'Enviar registro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
