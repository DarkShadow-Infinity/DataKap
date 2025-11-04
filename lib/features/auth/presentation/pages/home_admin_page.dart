import 'package:datakap/core/app_routes.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/dashboard_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAdminPage extends GetView<AuthController> {
  const HomeAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminUsers = Get.find<AdminUserController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de administración'),
      ),
      drawer: const _AdminDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AdminHeader(controller: controller),
                  const SizedBox(height: 24),
                  _SummarySection(adminUsers: adminUsers),
                  const SizedBox(height: 32),
                  Text(
                    'Acciones rápidas',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const _QuickActionsGrid(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;

      return Column(
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
        ],
      );
    });
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.adminUsers});

  final AdminUserController adminUsers;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = [
        _SummaryStat(
          label: 'Promovidos registrados',
          value:
              adminUsers.countByRole('promoter', status: 'registered').toString(),
          accent: AppColors.accent,
        ),
        _SummaryStat(
          label: 'Promovidos pendientes',
          value: adminUsers.countByRole('promoter', status: 'pending').toString(),
          accent: AppColors.warning,
        ),
        _SummaryStat(
          label: 'Promovidos rechazados',
          value:
              adminUsers.countByRole('promoter', status: 'rejected').toString(),
          accent: AppColors.danger,
        ),
        _SummaryStat(
          label: 'Líderes registrados',
          value: adminUsers.countByRole('leader', status: 'registered').toString(),
          accent: AppColors.accent,
        ),
        _SummaryStat(
          label: 'Líderes pendientes',
          value: adminUsers.countByRole('leader', status: 'pending').toString(),
          accent: AppColors.warning,
        ),
        _SummaryStat(
          label: 'Líderes rechazados',
          value: adminUsers.countByRole('leader', status: 'rejected').toString(),
          accent: AppColors.danger,
        ),
      ];

      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width >= 960 ? 3 : 2;
          final mainAxisExtent = width >= 720 ? 120.0 : 136.0;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: mainAxisExtent,
            ),
            itemBuilder: (context, index) => _SummaryCard(stat: stats[index]),
          );
        },
      );
    });
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        title: 'Gestión de usuarios',
        subtitle: 'Consulta, aprueba o rechaza promovidos y líderes.',
        icon: Icons.admin_panel_settings,
        color: AppColors.primary,
        onTap: () => Get.toNamed(AppRoutes.adminUserManagement),
      ),
      _QuickAction(
        title: 'Agregar promovido',
        subtitle: 'Envía una invitación con contraseña temporal.',
        icon: Icons.person_add_alt,
        color: AppColors.secondary,
        onTap: () => Get.toNamed(AppRoutes.adminAddPromoter),
      ),
      _QuickAction(
        title: 'Agregar líder',
        subtitle: 'Asigna metas y códigos de verificación.',
        icon: Icons.supervisor_account,
        color: AppColors.info,
        onTap: () => Get.toNamed(AppRoutes.adminAddLeader),
      ),
      _QuickAction(
        title: 'Sincronizar registros',
        subtitle: 'Envía la información capturada desde campo.',
        icon: Icons.sync,
        color: AppColors.warning,
        onTap: () => Get.toNamed(AppRoutes.registrationSync),
      ),
      _QuickAction(
        title: 'Ver Registros',
        subtitle: 'Ver todos los registros.',
        icon: Icons.list,
        color: AppColors.success,
        onTap: () => Get.toNamed(AppRoutes.registrations),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1100
            ? 3
            : width >= 760
                ? 2
                : 1;
        final mainAxisExtent = width >= 760 ? 204.0 : 224.0;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: mainAxisExtent,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return DashboardSectionCard(
              title: action.title,
              subtitle: action.subtitle,
              icon: action.icon,
              backgroundColor: action.color,
              onTap: action.onTap,
            );
          },
        );
      },
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
            onTap: () => Get.back(),
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
          const Divider(),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stat});

  final _SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stat.accent.withAlpha((255 * 0.2).round())),
        boxShadow: [
          BoxShadow(
            color: stat.accent.withAlpha((255 * 0.08).round()),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: stat.accent.withAlpha((255 * 0.9).round()),
                ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;
}

class _QuickAction {
  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}
