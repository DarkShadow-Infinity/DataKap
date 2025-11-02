import 'dart:async';

import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/entities/registration_sync_summary_entity.dart';
import 'package:datakap/features/registration/domain/use_cases/get_pending_registrations_use_case.dart';
import 'package:datakap/features/registration/domain/use_cases/sync_pending_registrations_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationSyncController extends GetxController {
  RegistrationSyncController({
    required GetPendingRegistrationsUseCase getPendingRegistrationsUseCase,
    required SyncPendingRegistrationsUseCase syncPendingRegistrationsUseCase,
    required NetworkInfo networkInfo,
  })  : _getPendingRegistrationsUseCase = getPendingRegistrationsUseCase,
        _syncPendingRegistrationsUseCase = syncPendingRegistrationsUseCase,
        _networkInfo = networkInfo;

  final GetPendingRegistrationsUseCase _getPendingRegistrationsUseCase;
  final SyncPendingRegistrationsUseCase _syncPendingRegistrationsUseCase;
  final NetworkInfo _networkInfo;

  final pendingRegistrations = <RegistrationEntity>[].obs;
  final isLoading = false.obs;
  final isSyncing = false.obs;
  final isOnline = true.obs;

  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    loadPending();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    isOnline.value = await _networkInfo.isConnected;
    _connectivitySubscription =
        _networkInfo.onStatusChange.listen((status) => isOnline.value = status);
  }

  Future<void> loadPending() async {
    isLoading.value = true;
    final result = await _getPendingRegistrationsUseCase();
    result.fold(
      (failure) {
        Get.snackbar(
          'Sincronización',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (registrations) {
        pendingRegistrations.assignAll(registrations);
      },
    );
    isLoading.value = false;
  }

  Future<void> syncAll() async {
    if (isSyncing.value) return;
    isSyncing.value = true;

    final result = await _syncPendingRegistrationsUseCase.execute();
    result.fold(
      (failure) {
        Get.snackbar(
          'Sincronización',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (summary) {
        _handleSyncSummary(summary);
      },
    );

    isSyncing.value = false;
  }

  void _handleSyncSummary(RegistrationSyncSummaryEntity summary) {
    // Assuming pending registrations are updated elsewhere or fetched again after sync
    // pendingRegistrations.assignAll(summary.pending); // This line might need adjustment based on actual logic

    final synced = summary.syncedToday;
    final failed = summary.failed;
    final totalAttempted = summary.pending + summary.syncedToday + summary.failed; // Calculate total attempted

    final title = synced > 0 && failed == 0
        ? 'Sincronización exitosa'
        : failed > 0
            ? 'Sincronización parcial'
            : 'Sin registros por sincronizar';
    final message = totalAttempted == 0
        ? 'No hay registros pendientes por sincronizar.'
        : 'Sincronizados: $synced • Fallidos: $failed';

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          failed > 0 ? Colors.orange.shade600 : Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}
