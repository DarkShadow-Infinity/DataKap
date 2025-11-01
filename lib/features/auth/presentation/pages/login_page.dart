import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores de texto para los campos de email y password
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Variable para manejar el mensaje de error de Firebase
    final errorMessage = ''.obs;

    // Estilo básico para los campos de texto
    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    );

    void loginUser() async {
      errorMessage.value = ''; // Limpiar errores anteriores
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Por favor, ingrese email y contraseña.';
        return;
      }

      // Llamada al método login del AuthController
      final error = await controller.login(email, password);

      if (error != null) {
        errorMessage.value = error;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('DataKap - Iniciar Sesión'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Título
              const Text(
                'Bienvenido a DataKap',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 40),

              // Campo de Email
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration.copyWith(hintText: 'ejemplo@datakap.com'),
              ),
              const SizedBox(height: 20),

              // Campo de Contraseña
              const Text('Contraseña', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: inputDecoration.copyWith(hintText: 'Mínimo 6 caracteres'),
              ),
              const SizedBox(height: 30),

              // Botón de Iniciar Sesión
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )),
              const SizedBox(height: 15),

              // Mostrar Error
              Obx(() => errorMessage.value.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              )
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
