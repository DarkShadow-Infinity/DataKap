import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';

class HomeRecabadorPage extends GetView<AuthController> {
  const HomeRecabadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataKap - Recolección'),
        backgroundColor: Colors.teal,
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
                leading: Icon(Icons.add_location_alt),
                title: Text('Nueva Encuesta'),
                // Aquí iría la navegación
              ),
              ListTile(
                leading: Icon(Icons.list_alt),
                title: Text('Encuestas Pendientes'),
              ),
              ListTile(
                leading: Icon(Icons.sync),
                title: Text('Sincronizar Datos'),
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
              'Listo para Recabar Datos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Usuario: ${controller.currentUser.value.email}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para empezar a recabar datos
                Get.snackbar('Acción', 'Iniciando nueva encuesta...', snackPosition: SnackPosition.BOTTOM);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Comenzar Nueva Encuesta'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
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
