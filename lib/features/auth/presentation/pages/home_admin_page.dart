import 'package:datakap/core/app_routes.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
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
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, administrador',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.currentUser.value.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
            ),
          ],
        ));
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.adminUsers});
  final AdminUserController adminUsers;

  @override
  Widget build(BuildContext context) {
    // Implementación de la sección de resumen
    return const Text('Summary Section Placeholder');
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    // Implementación de la grilla de acciones rápidas
    return const Text('Quick Actions Placeholder');
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
