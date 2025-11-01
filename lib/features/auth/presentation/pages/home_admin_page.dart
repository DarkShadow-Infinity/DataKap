import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';

class HomeAdminPage extends GetView<AuthController> {
  const HomeAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataKap - Panel de Administrador'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
            tooltip: 'Cerrar Sesión',
          )
        ],
      ),
      drawer: const Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text('Dashboard'),
                // Aquí iría la navegación Get.toNamed(AppRoutes.dashboard)
              ),
              ListTile(
                leading: Icon(Icons.group),
                title: Text('Gestión de Usuarios'),
              ),
              ListTile(
                leading: Icon(Icons.storage),
                title: Text('Ver Datos Recabados'),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenido, Administrador',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Usuario: ${controller.currentUser.value.email}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: controller.logout,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        )),
      ),
    );
  }
}
