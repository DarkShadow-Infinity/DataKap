import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/app.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/dashboard_section_card.dart';

class HomeAdminPage extends GetView<AuthController> {
  const HomeAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Cerrar sesión',
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final user = controller.currentUser.value;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido, administrador',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.blueGrey),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _SummaryChip(label: 'Promovidos registrados', value: '0'),
                    _SummaryChip(label: 'Promovidos pendientes', value: '0'),
                    _SummaryChip(label: 'Promovidos rechazados', value: '0'),
                    _SummaryChip(label: 'Líderes registrados', value: '0'),
                    _SummaryChip(label: 'Líderes pendientes', value: '0'),
                    _SummaryChip(label: 'Líderes rechazados', value: '0'),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Acciones rápidas',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 900 ? 3 : 2,
                  childAspectRatio: 1.1,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DashboardSectionCard(
                      title: 'Promovidos registrados',
                      subtitle: 'Consulta el historial de registros aprobados.',
                      icon: Icons.how_to_reg,
                      onTap: () {
                        Get.snackbar(
                          'Próximamente',
                          'Esta sección estará disponible en una siguiente versión.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    DashboardSectionCard(
                      title: 'Líderes registrados',
                      subtitle: 'Revisa los líderes que ya fueron validados.',
                      icon: Icons.verified_user,
                      backgroundColor: Colors.deepPurple,
                      onTap: () {
                        Get.snackbar(
                          'Próximamente',
                          'Esta sección estará disponible en una siguiente versión.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    DashboardSectionCard(
                      title: 'Promovidos pendientes',
                      subtitle: 'Aprueba o rechaza solicitudes en espera.',
                      icon: Icons.hourglass_bottom,
                      backgroundColor: Colors.orange,
                      onTap: () {
                        Get.snackbar(
                          'Próximamente',
                          'Esta sección estará disponible en una siguiente versión.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    DashboardSectionCard(
                      title: 'Líderes pendientes',
                      subtitle: 'Gestiona las cuentas que necesitan autorización.',
                      icon: Icons.assignment_turned_in,
                      backgroundColor: Colors.amber.shade700,
                      onTap: () {
                        Get.snackbar(
                          'Próximamente',
                          'Esta sección estará disponible en una siguiente versión.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    DashboardSectionCard(
                      title: 'Agregar promovido',
                      subtitle: 'Envía una invitación con contraseña temporal.',
                      icon: Icons.person_add,
                      backgroundColor: Colors.teal,
                      onTap: () => Get.toNamed(AppRoutes.adminAddPromoter),
                    ),
                    DashboardSectionCard(
                      title: 'Agregar líder',
                      subtitle: 'Asigna metas y códigos de verificación.',
                      icon: Icons.supervisor_account,
                      backgroundColor: Colors.deepPurple,
                      onTap: () => Get.toNamed(AppRoutes.adminAddLeader),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: Colors.blueGrey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blueGrey.shade100),
      ),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
