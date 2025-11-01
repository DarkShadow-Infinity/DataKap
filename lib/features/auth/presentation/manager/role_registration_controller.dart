import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

class RegistrationFieldConfig {
  const RegistrationFieldConfig({
    required this.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  final String key;
  final String label;
  final TextInputType keyboardType;
  final String? hint;
}

class RoleRegistrationController extends GetxController {
  RoleRegistrationController({
    required this.role,
    required this.requiresPhoto,
  });

  final UserRole role;
  final bool requiresPhoto;

  final formKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;
  final hasPhoto = false.obs;

  late final Map<String, TextEditingController> _controllers;

  Map<String, TextEditingController> get controllers => _controllers;

  String get roleLabel =>
      role == UserRole.leader ? 'líder' : 'promovido';

  static const List<RegistrationFieldConfig> fieldConfigs = [
    RegistrationFieldConfig(
      key: 'claveElectoral',
      label: 'Clave electoral',
      hint: 'Ingrese la clave tal como aparece en la credencial',
    ),
    RegistrationFieldConfig(
      key: 'sexo',
      label: 'Sexo',
    ),
    RegistrationFieldConfig(
      key: 'nombre',
      label: 'Nombre',
    ),
    RegistrationFieldConfig(
      key: 'apellidoPaterno',
      label: 'Apellido paterno',
    ),
    RegistrationFieldConfig(
      key: 'apellidoMaterno',
      label: 'Apellido materno',
    ),
    RegistrationFieldConfig(
      key: 'direccion',
      label: 'Dirección',
      hint: 'Calle, número y colonia',
    ),
    RegistrationFieldConfig(
      key: 'codigoPostal',
      label: 'Código postal',
      keyboardType: TextInputType.number,
    ),
    RegistrationFieldConfig(
      key: 'vigencia',
      label: 'Vigencia',
      hint: 'AAAA',
      keyboardType: TextInputType.number,
    ),
    RegistrationFieldConfig(
      key: 'estado',
      label: 'Estado',
    ),
    RegistrationFieldConfig(
      key: 'municipio',
      label: 'Municipio',
    ),
    RegistrationFieldConfig(
      key: 'localidad',
      label: 'Localidad',
    ),
    RegistrationFieldConfig(
      key: 'telefono',
      label: 'Teléfono',
      keyboardType: TextInputType.phone,
    ),
    RegistrationFieldConfig(
      key: 'whatsapp',
      label: 'WhatsApp',
      keyboardType: TextInputType.phone,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _controllers = {
      for (final config in fieldConfigs)
        config.key: TextEditingController(),
    };
  }

  @override
  void onClose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  void capturePhoto() {
    hasPhoto.value = true;
    Get.snackbar(
      'Foto capturada',
      'La imagen se guardará junto con el registro.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removePhoto() {
    hasPhoto.value = false;
  }

  Future<void> submitForm() async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (requiresPhoto && !hasPhoto.value) {
      Get.snackbar(
        'Foto requerida',
        'Captura la foto de la credencial INE antes de continuar.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.black,
      );
      return;
    }

    isSubmitting.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isSubmitting.value = false;

    Get.snackbar(
      'Registro enviado',
      'El ${roleLabel.toLowerCase()} ha sido registrado correctamente.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );

    for (final controller in _controllers.values) {
      controller.clear();
    }

    if (requiresPhoto) {
      hasPhoto.value = false;
    }
  }
}

class IneRegistrationController extends RoleRegistrationController {
  IneRegistrationController({required UserRole role})
      : super(role: role, requiresPhoto: true);
}

class ManualRegistrationController extends RoleRegistrationController {
  ManualRegistrationController({required UserRole role})
      : super(role: role, requiresPhoto: false);
}
