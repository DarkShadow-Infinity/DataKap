import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/registration_form_fields.dart';

class ManualRegistrationPage extends GetView<ManualRegistrationController> {
  const ManualRegistrationPage({super.key});

  String _roleLabel(UserRole role) =>
      role == UserRole.leader ? 'líder' : 'promovido';

  @override
  Widget build(BuildContext context) {
    final roleTitle =
        controller.role == UserRole.leader ? 'Líder' : 'Promovido';
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro manual - $roleTitle'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_note, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Captura todos los campos del ${_roleLabel(controller.role)} asegurándote de corroborar la información directamente con el ciudadano.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Formulario de registro',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.isOnline.value) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withAlpha((255 * 0.18).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.wifi_off, color: AppColors.warning),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Estás trabajando sin conexión. Los registros se guardarán en el dispositivo hasta que los sincronices.',
                            style: TextStyle(color: AppColors.warning),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                RegistrationFormFields(controller: controller),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton.icon(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.submitForm,
                      icon: controller.isSubmitting.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(controller.isSubmitting.value
                          ? 'Guardando registro...'
                          : 'Guardar registro'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
