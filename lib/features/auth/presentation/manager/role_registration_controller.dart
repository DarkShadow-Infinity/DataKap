import 'dart:async';

import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/use_cases/registration_request.dart';
import 'package:datakap/features/registration/domain/use_cases/submit_registration_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    required SubmitRegistrationUseCase submitRegistrationUseCase,
    required NetworkInfo networkInfo,
  })  : _submitRegistrationUseCase = submitRegistrationUseCase,
        _networkInfo = networkInfo;

  final UserRole role;
  final bool requiresPhoto;

  final formKey = GlobalKey<FormState>();
  final isSubmitting = false.obs;
  final hasPhoto = false.obs;
  final isOnline = true.obs;

  late final Map<String, TextEditingController> _controllers;

  Map<String, TextEditingController> get controllers => _controllers;

  String get roleLabel =>
      role == UserRole.leader ? 'líder' : 'promovido';

  StreamSubscription<bool>? _connectivitySubscription;
  final SubmitRegistrationUseCase _submitRegistrationUseCase;
  final NetworkInfo _networkInfo;

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
    _initializeConnectivity();
  }

  @override
  void onClose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    isOnline.value = await _networkInfo.isConnected;
    _connectivitySubscription =
        _networkInfo.onStatusChange.listen((status) => isOnline.value = status);
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
    try {
      final request = RegistrationRequest(
        role: role,
        fields: _buildFieldsMap(),
        requiresPhoto: requiresPhoto,
        photoPath: requiresPhoto ? 'ine_photo_${DateTime.now().millisecondsSinceEpoch}' : null,
      );

      final result = await _submitRegistrationUseCase.execute(request);
      result.fold(
        (failure) {
          Get.snackbar(
            'Error al registrar',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },
        (registration) {
          _handleSuccessfulSubmission(registration);
        },
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Map<String, String> _buildFieldsMap() {
    return {
      for (final entry in _controllers.entries)
        entry.key: entry.value.text.trim(),
      'rol': role.name,
    };
  }

  void _handleSuccessfulSubmission(RegistrationEntity registration) {
    for (final controller in _controllers.values) {
      controller.clear();
    }

    if (requiresPhoto) {
      hasPhoto.value = false;
    }

    final title = registration.isSynced ? 'Registro sincronizado' : 'Registro guardado';
    final message = registration.isSynced
        ? 'El ${roleLabel.toLowerCase()} se registró y sincronizó correctamente.'
        : 'El ${roleLabel.toLowerCase()} se guardó en el dispositivo. Podrás sincronizarlo cuando tengas internet.';

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          registration.isSynced ? Colors.green.shade600 : Colors.orange.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}

class IneRegistrationController extends RoleRegistrationController {
  IneRegistrationController({
    required UserRole role,
    required SubmitRegistrationUseCase submitRegistrationUseCase,
    required NetworkInfo networkInfo,
  }) : super(
          role: role,
          requiresPhoto: true,
          submitRegistrationUseCase: submitRegistrationUseCase,
          networkInfo: networkInfo,
        );
}

class ManualRegistrationController extends RoleRegistrationController {
  ManualRegistrationController({
    required UserRole role,
    required SubmitRegistrationUseCase submitRegistrationUseCase,
    required NetworkInfo networkInfo,
  }) : super(
          role: role,
          requiresPhoto: false,
          submitRegistrationUseCase: submitRegistrationUseCase,
          networkInfo: networkInfo,
        );
}
