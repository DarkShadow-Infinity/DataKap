import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';
import 'package:datakap/features/auth/domain/repositories/auth_repository.dart';

// Implementación concreta del repositorio de autenticación, siguiendo el contrato
// definido en la capa de Dominio (AuthRepository).
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
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
      // Intenta iniciar sesión a través de la fuente de datos remota
      final userModel = await remoteDataSource.signIn(email, password);

      // Si tiene éxito, retorna el UserEntity envuelto en Right (éxito)
      return Right(userModel);
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
      return Left(ServerFailure(message: 'An unknown error occurred during login: $e'));
    }
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
