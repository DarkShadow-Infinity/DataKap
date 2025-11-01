import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datakap/features/auth/presentation/manager/admin_user_form_controller.dart';
import 'package:datakap/features/auth/presentation/widgets/admin_user_form.dart';

class AdminAddLeaderPage extends GetView<AdminLeaderFormController> {
  const AdminAddLeaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar líder'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: const AdminUserForm(),
        ),
      ),
    );
  }
}
