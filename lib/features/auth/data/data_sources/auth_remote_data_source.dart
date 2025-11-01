import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/models/user_model.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Contrato para la capa de datos
abstract class AuthRemoteDataSource {
  Stream<UserEntity> get authStateChanges;
  Future<UserModel> signIn(String email, String password);
  Future<void> signOut();
}

// Implementación usando Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.localDataSource,
  });

  // Stream que escucha los cambios de autenticación de Firebase
  @override
  Stream<UserEntity> get authStateChanges {
    return auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return UserEntity.empty;
      }

      try {
        return _resolveUserModel(user);
      } on FirebaseException catch (e, stackTrace) {
        debugPrint(
          'FirebaseException while resolving auth state for ${user.uid}: '
          '${e.code} - ${e.message}\n$stackTrace',
        );
        return _fallbackToCachedUser(user.uid);
      } catch (e, stackTrace) {
        debugPrint(
          'Unknown error while resolving auth state for ${user.uid}: '
          '$e\n$stackTrace',
        );
        return _fallbackToCachedUser(user.uid);
      }
    });
  }

  // Iniciar sesión con email y contraseña
  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw StateError('Login exitoso pero usuario es nulo.');
      }

      return _resolveUserModel(user);
    } on TypeError catch (error, stackTrace) {
      debugPrint(
        'TypeError from signInWithEmailAndPassword: $error\n$stackTrace',
      );

      final fallbackUser = auth.currentUser ?? await _waitForAuthenticatedUser();
      if (fallbackUser != null) {
        debugPrint(
          'Recovered session using fallback user (${fallbackUser.uid}) '
          'after TypeError.',
        );
        return _resolveUserModel(fallbackUser);
      }

      rethrow;
    }
  }

  // Función auxiliar para obtener el rol del usuario de Firestore
  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(uid).get();
      if (!docSnapshot.exists) {
        return null;
      }

      return docSnapshot.data();
    } on FirebaseException catch (e, stackTrace) {
      debugPrint(
        'FirebaseException while fetching role data for $uid: '
        '${e.code} - ${e.message}\n$stackTrace',
      );
      return null;
    } catch (e, stackTrace) {
      debugPrint(
        'Unknown error while fetching role data for $uid: '
        '$e\n$stackTrace',
      );
      return null;
    }
  }

  // Cerrar sesión
  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<UserModel> _resolveUserModel(User user) async {
    final userData = await _getUserData(user.uid);

    final model = UserModel.fromFirebaseUser(user, userData);
    if (model != null) {
      await localDataSource.cacheUser(model);
      return model;
    }

    final cached = await localDataSource.getUserByUid(user.uid);
    if (cached != null) {
      return cached;
    }

    // Mientras se define la estrategia de roles, asumimos acceso de administrador.
    final fallback = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      role: UserRole.admin,
    );
    await localDataSource.cacheUser(fallback);
    return fallback;
  }

  Future<User?> _waitForAuthenticatedUser() async {
    final recoveryStreams = <MapEntry<String, Stream<User?>>>[
      MapEntry('authStateChanges', auth.authStateChanges()),
      MapEntry('idTokenChanges', auth.idTokenChanges()),
      MapEntry('userChanges', auth.userChanges()),
    ];

    for (final entry in recoveryStreams) {
      try {
        final user = await entry.value
            .firstWhere((user) => user != null)
            .timeout(const Duration(seconds: 3));
        if (user != null) {
          debugPrint(
            'Recovered authenticated user from ${entry.key}: ${user.uid}',
          );
          return user;
        }
      } on TimeoutException catch (error, stackTrace) {
        debugPrint(
          'Timeout waiting for ${entry.key} after TypeError: '
          '$error\n$stackTrace',
        );
      } catch (streamError, streamStackTrace) {
        debugPrint(
          'Error listening to ${entry.key} after TypeError: '
          '$streamError\n$streamStackTrace',
        );
      }
    }

    return null;
  }

  Future<UserEntity> _fallbackToCachedUser(String uid) async {
    final cached = await localDataSource.getUserByUid(uid);
    return cached ?? UserEntity.empty;
  }

  final AuthLocalDataSource localDataSource;
}
