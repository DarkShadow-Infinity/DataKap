import 'package:flutter/material.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';

class RegistrationFormFields extends StatelessWidget {
  const RegistrationFormFields({
    super.key,
    required this.controller,
  });

  final RoleRegistrationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final config in RoleRegistrationController.fieldConfigs)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              controller: controller.controllers[config.key],
              keyboardType: config.keyboardType,
              decoration: InputDecoration(
                labelText: config.label,
                hintText: config.hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa ${config.label.toLowerCase()}';
                }
                return null;
              },
            ),
          ),
      ],
    );
  }
}
