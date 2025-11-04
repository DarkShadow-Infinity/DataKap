import 'package:datakap/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/option_card.dart'; // <--- IMPORTAMOS EL NUEVO WIDGET
import 'package:datakap/features/auth/presentation/widgets/role_navigation_drawer.dart';

class RoleOptionsPage extends GetView<AuthController> {
  const RoleOptionsPage({
    super.key,
    required this.role,
  });

  final UserRole role;

  String get _roleTitle => role == UserRole.leader ? 'Líder' : 'Promovido';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataKap - $_roleTitle'),
      ),
      drawer: RoleNavigationDrawer(role: role, controller: controller),
      body: SafeArea(
        child: Obx(() {
          final email = controller.currentUser.value.email;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hola, $_roleTitle',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: AppColors.secondary.withAlpha((255 * 0.12).round())),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Cómo deseas registrar?',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Selecciona una opción para comenzar a registrar ciudadanos.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                OptionCard(
                  title: 'Registro con INE',
                  description:
                      'Captura la credencial, valida los datos y completa el formulario automáticamente.',
                  icon: Icons.credit_card,
                  color: AppColors.accent,
                  onTap: () => Get.toNamed(
                    AppRoutes.ineRegistration,
                    arguments: {'role': role},
                  ),
                ),
                const SizedBox(height: 16),
                OptionCard(
                  title: 'Registro manual',
                  description:
                      'Captura los datos manually si no tienes disponible la credencial INE.',
                  icon: Icons.edit_note,
                  color: AppColors.secondary,
                  onTap: () => Get.toNamed(
                    AppRoutes.manualRegistration,
                    arguments: {'role': role},
                  ),
                ),
                const SizedBox(height: 16),
                OptionCard(
                  title: 'Sincronizar registros',
                  description:
                      'Envía los registros guardados en el dispositivo cuando recuperes la conexión.',
                  icon: Icons.sync,
                  color: AppColors.warning,
                  onTap: () => Get.toNamed(
                    AppRoutes.registrationSync,
                    arguments: {'role': role},
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// La clase _OptionCard ha sido eliminada de este archivo.
