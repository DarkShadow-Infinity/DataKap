import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/registration/data/data_sources/registration_local_data_source.dart';
import 'package:datakap/features/registration/data/data_sources/registration_remote_data_source.dart';
import 'package:datakap/features/registration/data/models/registration_model.dart';
import 'package:datakap/features/registration/domain/entities/registration_entity.dart';
import 'package:datakap/features/registration/domain/entities/sync_summary_entity.dart';
import 'package:datakap/features/registration/domain/repositories/registration_repository.dart';
import 'package:datakap/features/registration/domain/use_cases/registration_request.dart';
import 'package:flutter/foundation.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl({
    required RegistrationRemoteDataSource remoteDataSource,
    required RegistrationLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  final RegistrationRemoteDataSource _remoteDataSource;
  final RegistrationLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, RegistrationEntity>> submitRegistration(
    RegistrationRequest request,
  ) async {
    try {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final initialModel = RegistrationModel.fromRequest(
        id: id,
        role: request.role,
        fields: request.fields,
        requiresPhoto: request.requiresPhoto,
        photoPath: request.photoPath,
      );

      await _localDataSource.upsert(initialModel);

      final hasConnection = await _networkInfo.isConnected;
      if (!hasConnection) {
        final offlineModel = initialModel.copyWith(
          isSynced: false,
          syncedAt: null,
          syncError: 'Sin conexión a internet. Se guardó en el dispositivo.',
        );
        await _localDataSource.upsert(offlineModel);
        return Right(offlineModel.toEntity());
      }

      try {
        await _remoteDataSource.sendRegistration(initialModel);
        final syncedModel = initialModel.copyWith(
          isSynced: true,
          syncedAt: DateTime.now(),
          syncError: null,
        );
        await _localDataSource.upsert(syncedModel);
        return Right(syncedModel.toEntity());
      } on FirebaseException catch (e, stackTrace) {
        debugPrint(
          'FirebaseException while sending registration ${initialModel.id}: '
          '${e.code} - ${e.message}\n$stackTrace',
        );
        final pendingModel = initialModel.copyWith(
          isSynced: false,
          syncedAt: null,
          syncError: e.message ?? 'No se pudo sincronizar el registro.',
        );
        await _localDataSource.upsert(pendingModel);
        return Right(pendingModel.toEntity());
      } catch (e, stackTrace) {
        debugPrint(
          'Unknown error while sending registration ${initialModel.id}: '
          '$e\n$stackTrace',
        );
        final pendingModel = initialModel.copyWith(
          isSynced: false,
          syncedAt: null,
          syncError: 'No se pudo sincronizar el registro: $e',
        );
        await _localDataSource.upsert(pendingModel);
        return Right(pendingModel.toEntity());
      }
    } catch (e) {
      return Left(CacheFailure(message: 'No se pudo guardar el registro localmente: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RegistrationEntity>>> getPendingRegistrations() async {
    try {
      final pending = await _localDataSource.getPending();
      return Right(pending.map((model) => model.toEntity()).toList(growable: false));
    } catch (e) {
      return Left(CacheFailure(message: 'No se pudieron leer los registros pendientes: $e'));
    }
  }

  @override
  Future<Either<Failure, SyncSummaryEntity>> syncPendingRegistrations() async {
    try {
      final hasConnection = await _networkInfo.isConnected;
      if (!hasConnection) {
        return Left(ServerFailure(message: 'Sin conexión a internet.'));
      }

      final pendingModels = await _localDataSource.getPending();
      if (pendingModels.isEmpty) {
        return const Right(SyncSummaryEntity(
          totalAttempted: 0,
          syncedCount: 0,
          failedCount: 0,
          pending: [],
        ));
      }

      var syncedCount = 0;
      var failedCount = 0;
      for (final model in pendingModels) {
        try {
          await _remoteDataSource.sendRegistration(model);
          final syncedModel = model.copyWith(
            isSynced: true,
            syncedAt: DateTime.now(),
            syncError: null,
          );
          await _localDataSource.upsert(syncedModel);
          syncedCount++;
        } on FirebaseException catch (e, stackTrace) {
          debugPrint(
            'FirebaseException while syncing ${model.id}: '
            '${e.code} - ${e.message}\n$stackTrace',
          );
          final failedModel = model.copyWith(
            isSynced: false,
            syncedAt: null,
            syncError: e.message ?? 'Error desconocido al sincronizar.',
          );
          await _localDataSource.upsert(failedModel);
          failedCount++;
        } catch (e, stackTrace) {
          debugPrint('Unknown error while syncing ${model.id}: $e\n$stackTrace');
          final failedModel = model.copyWith(
            isSynced: false,
            syncedAt: null,
            syncError: 'Error desconocido al sincronizar: $e',
          );
          await _localDataSource.upsert(failedModel);
          failedCount++;
        }
      }

      final remaining = await _localDataSource.getPending();
      return Right(SyncSummaryEntity(
        totalAttempted: pendingModels.length,
        syncedCount: syncedCount,
        failedCount: failedCount,
        pending: remaining.map((model) => model.toEntity()).toList(growable: false),
      ));
    } catch (e) {
      return Left(ServerFailure(message: 'No se pudieron sincronizar los registros: $e'));
    }
  }
}
