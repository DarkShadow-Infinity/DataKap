import 'package:get/get.dart';
import 'package:datakap/features/registration/domain/use_cases/create_registration_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/get_registrations_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/get_registration_by_id_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/update_registration_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/delete_registration_use_case.dart';

class RegistrationController extends GetxController {
  final CreateRegistrationUseCase createRegistrationUseCase;
  final GetRegistrationsUseCase getRegistrationsUseCase;
  final GetRegistrationByIdUseCase getRegistrationByIdUseCase;
  final UpdateRegistrationUseCase updateRegistrationUseCase;
  final DeleteRegistrationUseCase deleteRegistrationUseCase;

  RegistrationController({
    required this.createRegistrationUseCase,
    required this.getRegistrationsUseCase,
    required this.getRegistrationByIdUseCase,
    required this.updateRegistrationUseCase,
    required this.deleteRegistrationUseCase,
  });
}
