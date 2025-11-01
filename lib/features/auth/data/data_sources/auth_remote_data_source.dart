import 'package:cloud_firestore/cloud_firestore.dart';
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

  AuthRemoteDataSourceImpl({required this.auth, required this.firestore});

  // Stream que escucha los cambios de autenticación de Firebase
  @override
  Stream<UserEntity> get authStateChanges {
    return auth.authStateChanges().asyncMap((user) async {
      if (user == null) {
        return UserEntity.empty;
      }

      try {
        // Si hay usuario, buscamos su rol en Firestore
        final userData = await _getUserData(user.uid);
        return UserModel.fromFirebaseUser(user, userData) ?? UserEntity.empty;
      } on FirebaseException catch (e, stackTrace) {
        debugPrint(
          'FirebaseException while resolving auth state for ${user.uid}: '
          '${e.code} - ${e.message}\n$stackTrace',
        );
        return UserEntity.empty;
      } catch (e, stackTrace) {
        debugPrint(
          'Unknown error while resolving auth state for ${user.uid}: '
          '$e\n$stackTrace',
        );
        return UserEntity.empty;
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

      final currentUser = auth.currentUser;
      if (currentUser != null) {
        debugPrint(
          'Recovering session using currentUser (${currentUser.uid}) '
          'after TypeError.',
        );
        return _resolveUserModel(currentUser);
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
    if (model == null) {
      // Mientras se define la estrategia de roles, asumimos acceso de administrador.
      return UserModel(
        uid: user.uid,
        email: user.email ?? '',
        role: UserRole.admin,
      );
    }

    return model;
  }
}
