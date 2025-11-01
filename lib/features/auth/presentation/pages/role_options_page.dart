import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/app.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';

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
        backgroundColor:
            role == UserRole.leader ? Colors.deepPurple : Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
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
                  color: Colors.blueGrey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
                _OptionCard(
                  title: 'Registro con INE',
                  description:
                      'Captura la credencial, valida los datos y completa el formulario automáticamente.',
                  icon: Icons.credit_card,
                  color: Colors.teal,
                  onTap: () => Get.toNamed(
                    AppRoutes.ineRegistration,
                    arguments: {'role': role},
                  ),
                ),
                const SizedBox(height: 16),
                _OptionCard(
                  title: 'Registro manual',
                  description:
                      'Captura los datos manualmente si no tienes disponible la credencial INE.',
                  icon: Icons.edit_note,
                  color: Colors.indigo,
                  onTap: () => Get.toNamed(
                    AppRoutes.manualRegistration,
                    arguments: {'role': role},
                  ),
                ),
                const SizedBox(height: 16),
                _OptionCard(
                  title: 'Sincronizar registros',
                  description:
                      'Envía los registros guardados en el dispositivo cuando recuperes la conexión.',
                  icon: Icons.sync,
                  color: Colors.orange,
                  onTap: () => Get.toNamed(AppRoutes.registrationSync),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, color: Colors.blueGrey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Recuerda verificar que todos los datos estén completos y sean legibles antes de enviar el registro.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ],
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

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
