import 'package:datakap/core/app_routes.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleNavigationDrawer extends StatelessWidget {
  const RoleNavigationDrawer({
    super.key,
    required this.role,
    required this.controller,
  });

  final UserRole role;
  final AuthController controller;

  String get _roleTitle => role == UserRole.leader ? 'Líder' : 'Promovido';

  String get _homeRoute =>
      role == UserRole.leader ? AppRoutes.homeLeader : AppRoutes.homePromoter;

  void _closeDrawer(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
  }

  void _navigateTo(
    BuildContext context,
    String route, {
    Map<String, dynamic>? arguments,
  }) {
    _closeDrawer(context);
    if (Get.currentRoute == route) {
      return;
    }
    Get.toNamed(route, arguments: arguments);
  }

  void _goHome(BuildContext context) {
    _closeDrawer(context);
    if (Get.currentRoute == _homeRoute) {
      return;
    }
    Get.offAllNamed(_homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() {
              final user = controller.currentUser.value;
              return DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withAlpha((255 * 0.8).round()),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _roleTitle,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Inicio'),
                    onTap: () => _goHome(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Registro con INE'),
                    onTap: () => _navigateTo(
                      context,
                      AppRoutes.ineRegistration,
                      arguments: {'role': role},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit_note),
                    title: const Text('Registro manual'),
                    onTap: () => _navigateTo(
                      context,
                      AppRoutes.manualRegistration,
                      arguments: {'role': role},
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Sincronización'),
                    onTap: () => _navigateTo(
                      context,
                      AppRoutes.registrationSync,
                      arguments: {'role': role},
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                _closeDrawer(context);
                controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
