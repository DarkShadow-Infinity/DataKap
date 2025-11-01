import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Importamos el archivo generado por flutterfire configure
import 'firebase_options.dart';
import 'package:get/get.dart';

// Importamos el archivo donde definiremos las rutas y la DI
import 'core/app.dart';

void main() async {
  // 1. Asegurarse de que Flutter Widgets estén inicializados
  // ESTA LÍNEA DEBE IR ANTES DE CUALQUIER OTRA FUNCIÓN 'await' O ASÍNCRONA.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Firebase inicializado correctamente.");
  } catch (e) {
    debugPrint("Error al inicializar Firebase: $e");
    // Opcional: mostrar una pantalla de error si Firebase falla
  }

  // 3. Iniciar la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos GetMaterialApp en lugar de MaterialApp para la gestión de estado y rutas con GetX
    return GetMaterialApp(
      title: 'DataKap - Recolección de Datos',
      theme: ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity),
      // Definiremos la ruta inicial y el resto en el archivo 'core/app.dart'
      initialRoute: '/',
      getPages: AppPages.pages,
    );
  }
}
