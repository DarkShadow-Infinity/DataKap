import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/core/network/api_endpoint.dart';
import 'package:datakap/core/network/api_provider.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_result_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_summary_model.dart';

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  // El constructor ya no es necesario.

  @override
  Future<RegistrationModel> createRegistration(RegistrationModel registration) async {
    final response = await APIProvider.post(
      ApiEndPoint.createRegistration,
      data: registration.toJson(),
    ).request();

    if (response.success && response.data != null) {
      return registration.copyWith(
        id: response.data['id'],
        syncStatus: response.data['status'],
      );
    } else {
      throw ServerException(response.message);
    }
  }

  @override
  Future<List<RegistrationModel>> getRegistrations() async {
    final response = await APIProvider.get(ApiEndPoint.getRegistrations).request();

    if (response.success && response.data != null) {
      final List<dynamic> items = response.data['items'];
      return items.map((json) => RegistrationModel.fromJson(json)).toList();
    } else {
      throw ServerException(response.message);
    }
  }

  // ... (El resto de los métodos siguen el mismo patrón de `APIProvider.get(...).request()`)
  @override
  Future<RegistrationModel> getRegistration(String id) async {
    final response = await APIProvider.get(ApiEndPoint.getRegistrationById, urlArgs: [id]).request();

    if (response.success && response.data != null) {
      return RegistrationModel.fromJson(response.data);
    } else {
      throw ServerException(response.message);
    }
  }

  @override
  Future<RegistrationModel> updateRegistration(RegistrationModel registration) async {
    final response = await APIProvider.patch(
      ApiEndPoint.updateRegistration,
      urlArgs: [registration.id],
      data: registration.toJson(),
    ).request();

    if (response.success && response.data != null) {
      return RegistrationModel.fromJson(response.data);
    } else {
      throw ServerException(response.message);
    }
  }

  @override
  Future<void> deleteRegistration(String id) async {
    final response = await APIProvider.delete(ApiEndPoint.deleteRegistration, urlArgs: [id]).request();

    if (!response.success) {
      throw ServerException(response.message);
    }
  }

  @override
  Future<List<RegistrationSyncResultModel>> syncRegistrations(
      List<RegistrationModel> registrations) async {
    final response = await APIProvider.post(
      ApiEndPoint.syncRegistrations,
      data: {'registrations': registrations.map((e) => e.toJson()).toList()},
    ).request();

    if (response.success && response.data != null) {
      final List<dynamic> results = response.data['results'];
      return results.map((json) => RegistrationSyncResultModel.fromJson(json)).toList();
    } else {
      throw ServerException(response.message);
    }
  }

  @override
  Future<RegistrationSyncSummaryModel> getSyncSummary() async {
    final response = await APIProvider.get(ApiEndPoint.getSyncSummary).request();

    if (response.success && response.data != null) {
      return RegistrationSyncSummaryModel.fromJson(response.data);
    } else {
      throw ServerException(response.message);
    }
  }
}
