import 'dart:convert';

import 'package:datakap/core/error/error_response_model.dart';
import 'package:datakap/core/error/exceptions.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_result_model.dart';
import 'package:datakap/features/registration/data/models/registration_sync_summary_model.dart';
import 'package:http/http.dart' as http;

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final http.Client client;
  final String baseUrl = "https://api.datakap.mx"; // Replace with your actual base URL

  RegistrationRemoteDataSourceImpl({required this.client});

  @override
  Future<RegistrationModel> createRegistration(RegistrationModel registration) async {
    final response = await client.post(
      Uri.parse('$baseUrl/registrations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registration.toJson()),
    );

    if (response.statusCode == 200) {
      return RegistrationModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }

  @override
  Future<List<RegistrationModel>> getRegistrations() async {
    final response = await client.get(
      Uri.parse('$baseUrl/registrations'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['items'];
      return jsonList.map((json) => RegistrationModel.fromJson(json)).toList();
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }

  @override
  Future<RegistrationModel> getRegistration(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/registrations/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RegistrationModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }

  @override
  Future<RegistrationModel> updateRegistration(RegistrationModel registration) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/registrations/${registration.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registration.toJson()),
    );

    if (response.statusCode == 200) {
      return RegistrationModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }

  @override
  Future<void> deleteRegistration(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/registrations/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 422) {
        throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
      } else {
        throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
      }
    }
  }

  @override
  Future<List<RegistrationSyncResultModel>> syncRegistrations(List<RegistrationModel> registrations) async {
    final response = await client.post(
      Uri.parse('$baseUrl/registrations/sync'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(registrations.map((e) => e.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['results'];
      return jsonList.map((json) => RegistrationSyncResultModel.fromJson(json)).toList();
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }

  @override
  Future<RegistrationSyncSummaryModel> getSyncSummary() async {
    final response = await client.get(
      Uri.parse('$baseUrl/registrations/sync/summary'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return RegistrationSyncSummaryModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 422) {
      throw ValidationException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    } else {
      throw ServerException(ErrorResponseModel.fromJson(json.decode(response.body)).detail);
    }
  }
}
