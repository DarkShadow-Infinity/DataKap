import 'package:dio/dio.dart';

/// Clase simulada para gestionar el token de autenticación.
///
/// En una aplicación real, esto debería usar un almacenamiento seguro como
/// flutter_secure_storage para guardar y recuperar el token.
class AuthTokenManager {
  String? _token;

  // Método para obtener el token actual.
  // En un caso real, esto podría ser asíncrono.
  String? getToken() {
    // Simulación: aquí leerías el token desde el almacenamiento seguro.
    return _token;
  }

  // Método para guardar un nuevo token.
  Future<void> setToken(String token) async {
    // Simulación: aquí guardarías el token en el almacenamiento seguro.
    _token = token;
  }
}

/// Interceptor de Dio para añadir automáticamente el token de autenticación a las cabeceras.
///
/// Sobrescribe el método `onRequest` para modificar la petición antes de que se envíe.
class AuthInterceptor extends Interceptor {
  final AuthTokenManager _tokenManager;

  AuthInterceptor(this._tokenManager);

  /// Se llama antes de que la petición sea enviada.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Obtiene el token del gestor de tokens.
    final token = _tokenManager.getToken();

    // Si existe un token, lo añade a la cabecera 'Authorization' como un token Bearer.
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continúa con el flujo de la petición.
    super.onRequest(options, handler);
  }

  // También puedes sobrescribir onResponse y onError para manejar la renovación
  // de tokens (refresh token) si la API devuelve un error 401 Unauthorized.
}
