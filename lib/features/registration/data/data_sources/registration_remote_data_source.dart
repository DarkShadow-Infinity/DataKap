import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_summary_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_result_model.dart';

abstract class RegistrationRemoteDataSource {
  Future<RegistrationModel> createRegistration(RegistrationModel registration);
  Future<List<RegistrationModel>> getRegistrations();
  Future<RegistrationModel> getRegistration(String id);
  Future<RegistrationModel> updateRegistration(RegistrationModel registration);
  Future<void> deleteRegistration(String id);
  Future<List<RegistrationSyncResultModel>> syncRegistrations(List<RegistrationModel> registrations);
  Future<RegistrationSyncSummaryModel> getSyncSummary();
}