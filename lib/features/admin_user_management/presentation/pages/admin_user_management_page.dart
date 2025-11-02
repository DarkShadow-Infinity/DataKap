import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:datakap/core/presentation/so_notifier.dart';
import 'package:datakap/core/theme/app_theme.dart';
import 'package:datakap/features/admin_user_management/domain/entities/admin_user_entity.dart';
import 'package:datakap/features/admin_user_management/presentation/manager/admin_user_controller.dart';

class AdminUserManagementPage extends GetView<AdminUserController> {
  static const String routeName = '/admin/users/manage';
  const AdminUserManagementPage({super.key});

  void _manageAlerts(BuildContext context, SONotifier notifier) {
    final Color background;
    switch (notifier.type) {
      case SONotifierType.success:
        background = AppColors.accent;
        break;
      case SONotifierType.warning:
        background = AppColors.warning;
        break;
      case SONotifierType.error:
        background = AppColors.danger;
        break;
      case SONotifierType.info:
      background = AppColors.secondary;
    }

    if (notifier.message == null || notifier.message!.isEmpty) {
      return;
    }

    Get.snackbar(
      'Gestión de usuarios',
      notifier.message!,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: background,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminUserController>(
      initState: (_) {
        ever<SONotifier?>(controller.uiNotifier, (notifier) {
          if (notifier == null) return;
          _manageAlerts(context, notifier);
          controller.uiNotifier.value = null;
        });
      },
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gestión de usuarios'),
          ),
          body: GetBuilder<AdminUserController>(
            id: 'admin-users',
            builder: (_) {
              return Obx(() {
                if (controller.isLoading.value && controller.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = controller.filteredUsers;

                return RefreshIndicator(
                  onRefresh: () => controller.fetchData(''),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _Header(filterRole: controller.filterRole),
                      const SizedBox(height: 24),
                      if (users.isEmpty)
                        const _EmptyState()
                      else
                        _UserTable(
                          users: users,
                          onApprove: (user) => controller.toggleStatus(user, 'registered'),
                          onReject: (user) => controller.toggleStatus(user, 'rejected'),
                          onDelete: (user) => controller.deleteUser(user.id),
                        ),
                    ],
                  ),
                );
              });
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showCreateUserSheet(context),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Agregar usuario'),
          ),
        );
      },
    );
  }

  void _showCreateUserSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final goalController = TextEditingController();
    final verificationController = TextEditingController();
    String role = 'promoter';

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Agregar usuario',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: role,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    items: const [
                      DropdownMenuItem(value: 'promoter', child: Text('Promovido')),
                      DropdownMenuItem(value: 'leader', child: Text('Líder')),
                    ],
                    onChanged: (value) {
                      role = value ?? 'promoter';
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre completo'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Correo electrónico'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el correo';
                      }
                      if (!value.contains('@')) {
                        return 'El correo no es válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: goalController,
                    decoration: const InputDecoration(labelText: 'Meta de registros'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: verificationController,
                    decoration: const InputDecoration(labelText: 'Código de verificación'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (!(formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      final goal = int.tryParse(goalController.text.trim());
                      final success = await controller.createUser(
                        email: emailController.text.trim(),
                        fullName: nameController.text.trim(),
                        phone: phoneController.text.trim(),
                        role: role,
                        goal: goal ?? 0,
                        verificationCode: verificationController.text.trim(),
                      );
                      if (success) {
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Guardar usuario'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      goalController.dispose();
      verificationController.dispose();
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.filterRole});

  final RxString filterRole;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usuarios registrados',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Administra promovidos y líderes, actualiza su estado y corrige la información pendiente.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 16),
        Obx(() {
          return Wrap(
            spacing: 12,
            children: [
              ChoiceChip(
                label: const Text('Todos'),
                selected: filterRole.value.isEmpty,
                onSelected: (_) => filterRole.value = '',
              ),
              ChoiceChip(
                label: const Text('Promovidos'),
                selected: filterRole.value == 'promoter',
                onSelected: (_) => filterRole.value = 'promoter',
              ),
              ChoiceChip(
                label: const Text('Líderes'),
                selected: filterRole.value == 'leader',
                onSelected: (_) => filterRole.value = 'leader',
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _UserTable extends StatelessWidget {
  const _UserTable({
    required this.users,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
  });

  final List<AdminUserEntity> users;
  final ValueChanged<AdminUserEntity> onApprove;
  final ValueChanged<AdminUserEntity> onReject;
  final ValueChanged<AdminUserEntity> onDelete;

  Color _badgeColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.danger;
      case 'registered':
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Correo')),
            DataColumn(label: Text('Rol')),
            DataColumn(label: Text('Meta')),
            DataColumn(label: Text('Estado')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.fullName.isEmpty ? 'Sin nombre' : user.fullName)),
                DataCell(Text(user.email)),
                DataCell(Text(user.role == 'leader' ? 'Líder' : 'Promovido')),
                DataCell(Text(user.goal.toString())),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _badgeColor(user.status).withAlpha((255 * 0.12).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.status == 'pending'
                          ? 'Pendiente'
                          : user.status == 'rejected'
                              ? 'Rechazado'
                              : 'Registrado',
                      style: TextStyle(
                        color: _badgeColor(user.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        tooltip: 'Aprobar',
                        icon: const Icon(Icons.check_circle_outline, color: AppColors.accent),
                        onPressed: () => onApprove(user),
                      ),
                      IconButton(
                        tooltip: 'Rechazar',
                        icon: const Icon(Icons.block, color: AppColors.danger),
                        onPressed: () => onReject(user),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete_outline, color: AppColors.secondary),
                        onPressed: () => onDelete(user),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withAlpha((255 * 0.12).round())),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, color: AppColors.secondary.withAlpha((255 * 0.6).round()), size: 60),
          const SizedBox(height: 16),
          Text(
            'Aún no hay usuarios registrados',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Utiliza el botón "Agregar usuario" para enviar invitaciones a promovidos y líderes.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}
