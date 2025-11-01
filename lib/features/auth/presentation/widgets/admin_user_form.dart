import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/admin_user_form_controller.dart';

class AdminUserForm extends GetView<AdminUserFormController> {
  const AdminUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: controller.emailController,
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa el correo del ${controller.roleLabel}';
              }
              if (!value.contains('@')) {
                return 'El correo no es válido';
              }
              return null;
            },
          ),
          _buildTextField(
            controller: controller.tempPasswordController,
            label: 'Contraseña temporal',
            obscureText: true,
          ),
          _buildTextField(
            controller: controller.fullNameController,
            label: 'Nombre completo',
          ),
          _buildTextField(
            controller: controller.phoneController,
            label: 'Teléfono',
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(
            controller: controller.goalController,
            label: 'Meta',
            hint: 'Número de registros esperados',
            keyboardType: TextInputType.number,
          ),
          _buildTextField(
            controller: controller.verificationCodeController,
            label: 'Código de verificación',
            hint: 'Se solicitará al acceder por primera vez',
          ),
          const SizedBox(height: 24),
          Obx(() => ElevatedButton.icon(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitForm,
                icon: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  controller.isSubmitting.value
                      ? 'Enviando...'
                      : 'Enviar invitación',
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator ?? (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ingresa ${label.toLowerCase()}';
          }
          return null;
        },
      ),
    );
  }
}
