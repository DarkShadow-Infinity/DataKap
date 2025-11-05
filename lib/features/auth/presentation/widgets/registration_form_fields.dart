import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/role_registration_controller.dart';

class RegistrationFormFields extends StatelessWidget {
  final RoleRegistrationController controller;

  const RegistrationFormFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final config in RoleRegistrationController.fieldConfigs)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Builder(builder: (context) {
              if (config.key == 'localidad') {
                return Obx(() => DropdownButtonFormField<String>(
                      value: controller.localities.contains(controller.selectedLocality.value)
                          ? controller.selectedLocality.value
                          : null,
                      items: controller.localities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.selectedLocality.value = newValue;
                        }
                      },
                      decoration: InputDecoration(labelText: config.label, hintText: config.hint),
                    ));
              } else {
                return TextFormField(
                  controller: controller.controllers[config.key],
                  decoration: InputDecoration(labelText: config.label, hintText: config.hint),
                  keyboardType: config.keyboardType,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                );
              }
            }),
          )
      ],
    );
  }
}
