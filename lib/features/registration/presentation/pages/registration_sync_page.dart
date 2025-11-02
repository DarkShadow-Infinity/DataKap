import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/role_navigation_drawer.dart';
import 'package:datakap/features/registration/presentation/manager/registration_sync_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegistrationSyncPage extends GetView<RegistrationSyncController> {
  const RegistrationSyncPage({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final authController = Get.find<AuthController>();
    final args = Get.arguments as Map<String, dynamic>?;
    final roleArg = args?['role'] as UserRole?;
    final inferredRole = roleArg ?? authController.currentUser.value.role;
    final role =
        inferredRole == UserRole.unknown ? UserRole.promoter : inferredRole;
    final showDrawer = role == UserRole.promoter || role == UserRole.leader;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
        title: const Text('Sincronización de registros'),
        actions: [
          if (showDrawer)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Abrir menú',
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          Obx(() => IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Actualizar lista',
                onPressed:
                    controller.isLoading.value ? null : controller.loadPending,
              )),
        ],
      ),
      drawer: showDrawer
          ? RoleNavigationDrawer(role: role, controller: authController)
          : null,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = controller.pendingRegistrations;
          final listView = RefreshIndicator(
            onRefresh: controller.loadPending,
            child: items.isEmpty
                ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Icon(Icons.cloud_done, size: 72, color: Colors.green),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'No hay registros pendientes por sincronizar.',
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, index) {
                      final registration = items[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: registration.syncError == null
                                ? Colors.blueGrey.shade200
                                : Colors.redAccent,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    registration.requiresPhoto
                                        ? Icons.credit_card
                                        : Icons.edit_note,
                                    color: registration.requiresPhoto
                                        ? Colors.teal
                                        : Colors.indigo,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    registration.role == UserRole.leader
                                        ? 'Registro de líder'
                                        : 'Registro de promovido',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Text(
                                    dateFormat.format(registration.createdAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: registration.fields.entries
                                    .where((entry) => entry.key != 'rol')
                                    .map((entry) => _FieldChip(
                                          label: entry.key,
                                          value: entry.value,
                                        ))
                                    .toList(),
                              ),
                              if (registration.syncError != null) ...[
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.error, color: Colors.redAccent),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        registration.syncError!,
                                        style: const TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length,
                    ),
          );
          return Column(
            children: [
              if (!controller.isOnline.value)
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: const [
                      Icon(Icons.wifi_off, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sin conexión. Los registros pendientes se enviarán cuando sincronices manualmente.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(child: listView),
            ],
          );
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.pendingRegistrations.isEmpty) {
          return const SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: controller.isSyncing.value ? null : controller.syncAll,
          icon: controller.isSyncing.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.cloud_upload),
          label: Text(controller.isSyncing.value ? 'Sincronizando...' : 'Sincronizar todo'),
        );
      }),
    );
  }
}

class _FieldChip extends StatelessWidget {
  const _FieldChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.blueGrey.shade50,
    );
  }
}
