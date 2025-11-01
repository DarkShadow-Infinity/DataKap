import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/core/network/network_info.dart';
import 'package:datakap/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// Implementación concreta del repositorio de autenticación, siguiendo el contrato
// definido en la capa de Dominio (AuthRepository).
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirebaseAuth firebaseAuth;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.firebaseAuth,
  });

  // Escucha los cambios de estado de autenticación (logueado/deslogueado).
  // La fuente de datos remota es responsable de mapear el objeto de Firebase (User)
  // a nuestra entidad de dominio (UserEntity).
  @override
  Stream<UserEntity> get authStateChanges => remoteDataSource.authStateChanges;

  // Implementación del método de login definido en el contrato.
  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final hasConnection = await networkInfo.isConnected;
      if (!hasConnection) {
        final cached = await localDataSource.getUserByEmail(email);
        if (cached != null) {
          return Right(cached);
        }

        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null) {
          final cachedByUid = await localDataSource.getUserByUid(currentUser.uid);
          if (cachedByUid != null) {
            return Right(cachedByUid);
          }
        }

        return Left(
          ServerFailure(
            message:
                'Sin conexión a internet. Conéctate al menos una vez para validar tus credenciales.',
          ),
        );
      }

      // Intenta iniciar sesión a través de la fuente de datos remota
      final userModel = await remoteDataSource.signIn(email, password);

      // Si tiene éxito, retorna el UserEntity envuelto en Right (éxito)
      return Right(userModel);
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('FirebaseAuthException during login: ${e.code} - ${e.message}\n$stackTrace');
      return Left(AuthFailure(message: _mapFirebaseAuthException(e)));
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('FirebaseException during login: ${e.code} - ${e.message}\n$stackTrace');
      return Left(ServerFailure(message: _mapFirebaseException(e)));
    } on TypeError catch (e, stackTrace) {
      debugPrint('TypeError during login: $e\n$stackTrace');
      return Left(
        ServerFailure(
          message:
              'Ocurrió un error al procesar la respuesta de inicio de sesión. '
              'Intenta actualizar la aplicación e inténtalo nuevamente.',
        ),
      );
    } on StateError catch (e, stackTrace) {
      debugPrint('StateError during login: ${e.message}\n$stackTrace');
      return Left(DataFailure(message: e.message));
    } on AuthFailure catch (e) {
      // Captura fallas de autenticación específicas (ej: credenciales inválidas)
      return Left(AuthFailure(message: e.message));
    } on ServerFailure catch (e) {
      // Captura fallas de servidor/Firebase genéricas
      return Left(ServerFailure(message: e.message));
    } on DataFailure catch (e) {
      // Captura fallas de datos (ej: usuario logueado pero sin rol válido)
      return Left(DataFailure(message: e.message));
    } catch (e) {
      // Captura cualquier otro error desconocido
      debugPrint('Unknown error during login: $e');
      return Left(ServerFailure(message: 'Ocurrió un error inesperado al iniciar sesión. Inténtalo nuevamente.'));
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'El correo electrónico no tiene un formato válido.';
      case 'user-disabled':
        return 'El usuario ha sido deshabilitado. Contacta al administrador.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Credenciales incorrectas. Verifica tu email y contraseña.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Inténtalo más tarde.';
      case 'network-request-failed':
        return 'Sin conexión a internet. Revisa tu conexión e inténtalo de nuevo.';
      default:
        return exception.message ?? 'No se pudo iniciar sesión. Inténtalo nuevamente.';
    }
  }

  String _mapFirebaseException(FirebaseException exception) {
    final message = exception.message ?? '';

    if (exception.code == 'not-found' ||
        message.contains('does not exist for project')) {
      return 'La base de datos de Firestore no está configurada. Habilita Firestore en tu proyecto de Firebase.';
    }

    if (exception.code == 'unavailable') {
      return 'El servicio de Firestore no está disponible en este momento. Verifica la configuración del proyecto en Firebase y tu conexión.';
    }

    return message.isNotEmpty
        ? message
        : 'Ocurrió un error con Firebase. Inténtalo nuevamente.';
  }

  // Implementación del método de logout definido en el contrato.
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerFailure catch (e) {
      // Captura fallas de servidor/Firebase durante el cierre de sesión
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unknown error occurred during logout: $e'));
    }
  }
}
