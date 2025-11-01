import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datakap/features/auth/data/models/user_model.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

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
      // Si hay usuario, buscamos su rol en Firestore
      final userData = await _getUserData(user.uid);
      return UserModel.fromFirebaseUser(user, userData) ?? UserEntity.empty;
    });
  }

  // Iniciar sesión con email y contraseña
  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Login exitoso pero usuario es nulo.');
    }

    // Obtener los datos adicionales (rol) del usuario de Firestore
    final userData = await _getUserData(user.uid);
    if (userData == null) {
      // Si el usuario existe en Auth pero no en Firestore, es un problema de Data
      throw Exception('Datos de usuario (rol) no encontrados en Firestore.');
    }

    // Retornar el modelo completo
    return UserModel.fromFirebaseUser(user, userData)!;
  }

  // Función auxiliar para obtener el rol del usuario de Firestore
  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    final docSnapshot = await firestore.collection('users').doc(uid).get();
    return docSnapshot.data();
  }

  // Cerrar sesión
  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
