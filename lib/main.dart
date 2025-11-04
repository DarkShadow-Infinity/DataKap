import 'package:datakap/core/app.dart';
import 'package:datakap/core/app_routes.dart';
import 'package:datakap/core/model/registration_model.dart';
import 'package:datakap/core/network/api_provider.dart';
import 'package:datakap/core/network/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inyección de dependencias de red
  final tokenManager = Get.put<AuthTokenManager>(AuthTokenManager(), permanent: true);
  Get.put<Dio>(
    createApiDio(tokenManager: tokenManager),
    permanent: true,
  );

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint("Firebase inicializado correctamente.");
  } catch (e) {
    debugPrint("Error al inicializar Firebase: $e");
  }

  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(RegistrationModelAdapter().typeId)) {
    Hive.registerAdapter(RegistrationModelAdapter());
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DataKap - Recolección de Datos',
      theme: AppTheme.light,
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
    );
  }
}
