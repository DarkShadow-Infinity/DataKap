import 'package:equatable/equatable.dart';

// Clase base abstracta para todos los tipos de fallas/errores en la aplicación.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// 1. Fallas relacionadas con problemas de red o servidor (ej: 404, timeout, error de Firebase).
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

// 2. Fallas relacionadas con la autenticación (ej: credenciales inválidas, usuario no encontrado).
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

// 3. Fallas relacionadas con datos (ej: datos mal formados, campo faltante, usuario sin rol).
class DataFailure extends Failure {
  const DataFailure({required super.message});
}

// 4. Fallas relacionadas con el caché o almacenamiento local (ej: error al leer/escribir en el disco).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

// 5. Fallas relacionadas con la conectividad de red.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No hay conexión a internet.'});
}

// 6. Fallas relacionadas con la validación de datos (ej: entrada de usuario inválida).
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
