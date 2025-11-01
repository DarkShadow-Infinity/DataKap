import 'package:dartz/dartz.dart';
import 'package:datakap/core/error/failures.dart';
import 'package:datakap/features/auth/domain/entities/user_entity.dart';

// El repositorio define las operaciones de la lógica de negocio.
abstract class AuthRepository {
  // Retorna un stream que emite el estado del usuario cada vez que cambia
  Stream<UserEntity> get authStateChanges;

  // Realiza el login. Retorna el usuario o una Falla.
  Future<Either<Failure, UserEntity>> login(String email, String password);

  // Realiza el logout.
  Future<Either<Failure, void>> logout();
}
