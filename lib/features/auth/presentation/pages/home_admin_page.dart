import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/core/app.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/dashboard_section_card.dart';

class HomeAdminPage extends GetView<AuthController> {
  const HomeAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminUsers = Get.find<AdminUserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Cerrar sesión',
          )
        ],
      ),
      drawer: const _AdminDrawer(),
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
                      ?.copyWith(color: AppColors.secondary),
                ),
                const SizedBox(height: 24),
                Obx(() {
                  final promoterRegistered =
                      adminUsers.countByRole('promoter', status: 'registered');
                  final promoterPending =
                      adminUsers.countByRole('promoter', status: 'pending');
                  final promoterRejected =
                      adminUsers.countByRole('promoter', status: 'rejected');
                  final leaderRegistered =
                      adminUsers.countByRole('leader', status: 'registered');
                  final leaderPending =
                      adminUsers.countByRole('leader', status: 'pending');
                  final leaderRejected =
                      adminUsers.countByRole('leader', status: 'rejected');

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _SummaryChip(
                        label: 'Promovidos registrados',
                        value: promoterRegistered.toString(),
                        accent: AppColors.accent,
                      ),
                      _SummaryChip(
                        label: 'Promovidos pendientes',
                        value: promoterPending.toString(),
                        accent: AppColors.warning,
                      ),
                      _SummaryChip(
                        label: 'Promovidos rechazados',
                        value: promoterRejected.toString(),
                        accent: AppColors.danger,
                      ),
                      _SummaryChip(
                        label: 'Líderes registrados',
                        value: leaderRegistered.toString(),
                        accent: AppColors.accent,
                      ),
                      _SummaryChip(
                        label: 'Líderes pendientes',
                        value: leaderPending.toString(),
                        accent: AppColors.warning,
                      ),
                      _SummaryChip(
                        label: 'Líderes rechazados',
                        value: leaderRejected.toString(),
                        accent: AppColors.danger,
                      ),
                    ],
                  );
                }),
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
                      title: 'Gestión de usuarios',
                      subtitle: 'Consulta, aprueba o rechaza promovidos y líderes.',
                      icon: Icons.admin_panel_settings,
                      backgroundColor: AppColors.primary,
                      onTap: () => Get.toNamed(AppRoutes.adminUserManagement),
                    ),
                    DashboardSectionCard(
                      title: 'Agregar promovido',
                      subtitle: 'Envía una invitación con contraseña temporal.',
                      icon: Icons.person_add_alt,
                      backgroundColor: AppColors.secondary,
                      onTap: () => Get.toNamed(AppRoutes.adminAddPromoter),
                    ),
                    DashboardSectionCard(
                      title: 'Agregar líder',
                      subtitle: 'Asigna metas y códigos de verificación.',
                      icon: Icons.supervisor_account,
                      backgroundColor: AppColors.info,
                      onTap: () => Get.toNamed(AppRoutes.adminAddLeader),
                    ),
                    DashboardSectionCard(
                      title: 'Sincronizar registros',
                      subtitle: 'Envía la información capturada desde campo.',
                      icon: Icons.sync,
                      backgroundColor: AppColors.warning,
                      onTap: () => Get.toNamed(AppRoutes.registrationSync),
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

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final email = authController.currentUser.value.email;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Administrador'),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings, color: AppColors.primary),
            ),
            decoration: const BoxDecoration(color: AppColors.primary),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_customize_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: const Text('Gestión de Usuarios'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.adminUserManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage_rounded),
            title: const Text('Ver datos recabados'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.registrationSync);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Get.back();
              authController.logout();
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accent.withOpacity(0.2)),
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
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: accent.withOpacity(0.8)),
            ),
        ],
      ),
    );
  }
}
