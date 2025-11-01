import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';
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
        backgroundColor:
            controller.role == UserRole.leader ? Colors.deepPurple : Colors.teal,
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
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Captura la credencial INE del ${_roleLabel(controller.role)} y verifica que la imagen sea legible.',
                          style: Theme.of(context).textTheme.bodyMedium,
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
                              ? Colors.green
                              : Colors.blueGrey.shade200,
                          width: 2,
                        ),
                        color: controller.hasPhoto.value
                            ? Colors.green.shade50
                            : Colors.grey.shade100,
                      ),
                      child: Center(
                        child: controller.hasPhoto.value
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                                  SizedBox(height: 12),
                                  Text('Foto registrada correctamente'),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.credit_card, size: 48, color: Colors.blueGrey),
                                  SizedBox(height: 12),
                                  Text('Aún no se ha capturado la credencial'),
                                ],
                              ),
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: controller.capturePhoto,
                            icon: Icon(
                              controller.hasPhoto.value
                                  ? Icons.refresh
                                  : Icons.camera_alt,
                            ),
                            label: Text(
                              controller.hasPhoto.value
                                  ? 'Capturar nuevamente'
                                  : 'Capturar foto',
                            ),
                          ),
                        ),
                        if (controller.hasPhoto.value) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.removePhoto,
                              icon: const Icon(Icons.delete),
                              label: const Text('Eliminar foto'),
                            ),
                          ),
                        ],
                      ],
                    )),
                const SizedBox(height: 32),
                Text(
                  'Completa los datos del ${_roleLabel(controller.role)}',
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
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.wifi_off, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'El registro se guardará en el dispositivo porque no hay conexión. Podrás sincronizarlo más tarde.',
                            style: TextStyle(color: Colors.orange),
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
                          : const Icon(Icons.send),
                      label: Text(controller.isSubmitting.value
                          ? 'Enviando registro...'
                          : 'Enviar registro'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
