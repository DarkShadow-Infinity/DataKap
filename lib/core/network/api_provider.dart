import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;

import 'api_endpoint.dart';
import 'auth_interceptor.dart';
import 'request_interceptor.dart';
import 'so_api_response.dart';

enum _APIMethod { get, post, put, patch, delete }

/// Crea un Dio de uso global para tu API.
/// Regístralo en GetX: `Get.put<Dio>(createApiDio(tokenManager: tm), permanent: true);`
Dio createApiDio({required AuthTokenManager tokenManager}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        // Se usa 10.0.2.2 como default para desarrollo en emulador Android.
        defaultValue: 'http://192.168.5.178:8000',
      ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      validateStatus: (code) => code != null, // no lanzar en 4xx/5xx
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(RequestInterceptor());
  }

  // Interceptor de auth (ideal: soporte de refresh + reintento en 401)
  dio.interceptors.add(AuthInterceptor(tokenManager));

  return dio;
}

class APIProvider {
  // Campos inmutables de la request
  final _APIMethod _method;
  final ApiEndPoint _endpoint;
  final dynamic _data;
  final List<String>? _urlArgs;
  final Map<String, dynamic>? _query;

  // `Dio` inyectado (singleton), por defecto tomado de Get.find<Dio>()
  final Dio _dio;

  const APIProvider._({
    required _APIMethod method,
    required ApiEndPoint endpoint,
    required Dio dio,
    dynamic data,
    List<String>? urlArgs,
    Map<String, dynamic>? query,
    bool useAuthToken = true,
  })  : _method = method,
        _endpoint = endpoint,
        _dio = dio,
        _data = data,
        _urlArgs = urlArgs,
        _query = query;

  /// Si no pasas `dio`, intentará obtenerlo con `Get.find<Dio>()`.
  static Dio _resolveDio(Dio? dio) => dio ?? Get.find<Dio>();

  // ---------- Factories ----------
  factory APIProvider.get(
      ApiEndPoint endpoint, {
        List<String>? urlArgs,
        Map<String, dynamic>? query,
        bool useAuth = true,
        Dio? dio,
      }) {
    return APIProvider._(
      method: _APIMethod.get,
      endpoint: endpoint,
      urlArgs: urlArgs,
      query: query,
      useAuthToken: useAuth,
      dio: _resolveDio(dio),
    );
  }

  factory APIProvider.post(
      ApiEndPoint endpoint, {
        dynamic data,
        List<String>? urlArgs,
        Map<String, dynamic>? query,
        bool useAuth = true,
        Dio? dio,
      }) {
    return APIProvider._(
      method: _APIMethod.post,
      endpoint: endpoint,
      data: data,
      urlArgs: urlArgs,
      query: query,
      useAuthToken: useAuth,
      dio: _resolveDio(dio),
    );
  }

  factory APIProvider.put(
      ApiEndPoint endpoint, {
        dynamic data,
        List<String>? urlArgs,
        Map<String, dynamic>? query,
        bool useAuth = true,
        Dio? dio,
      }) {
    return APIProvider._(
      method: _APIMethod.put,
      endpoint: endpoint,
      data: data,
      urlArgs: urlArgs,
      query: query,
      useAuthToken: useAuth,
      dio: _resolveDio(dio),
    );
  }

  factory APIProvider.patch(
      ApiEndPoint endpoint, {
        dynamic data,
        List<String>? urlArgs,
        Map<String, dynamic>? query,
        bool useAuth = true,
        Dio? dio,
      }) {
    return APIProvider._(
      method: _APIMethod.patch,
      endpoint: endpoint,
      data: data,
      urlArgs: urlArgs,
      query: query,
      useAuthToken: useAuth,
      dio: _resolveDio(dio),
    );
  }

  factory APIProvider.delete(
      ApiEndPoint endpoint, {
        dynamic data, // permitir body en DELETE
        List<String>? urlArgs,
        Map<String, dynamic>? query,
        bool useAuth = true,
        Dio? dio,
      }) {
    return APIProvider._(
      method: _APIMethod.delete,
      endpoint: endpoint,
      data: data,
      urlArgs: urlArgs,
      query: query,
      useAuthToken: useAuth,
      dio: _resolveDio(dio),
    );
  }

  // ---------- Ejecución ----------
  Future<SOApiResponse> request() async {
    // Nota: El AuthInterceptor ya debe estar agregado al Dio global si _useAuthToken == true.
    // Si quisieras omitir token para esta request específica, podrías clonar el Dio y quitar el interceptor,
    // pero lo común es tener un Dio para "autenticado" y, si necesitas, otro para "público".

    try {
      final response = await _performRequest(_dio);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    }
  }

  Future<Response> _performRequest(Dio dio) {
    final url = _buildUrl();
    final qp = _query;

    switch (_method) {
      case _APIMethod.get:
        return dio.get(url, queryParameters: qp);
      case _APIMethod.post:
        return dio.post(url, data: _data, queryParameters: qp);
      case _APIMethod.patch:
        return dio.patch(url, data: _data, queryParameters: qp);
      case _APIMethod.put:
        return dio.put(url, data: _data, queryParameters: qp);
      case _APIMethod.delete:
        return dio.delete(url, data: _data, queryParameters: qp);
    }
  }

  String _buildUrl() {
    // Construcción segura del path usando encode de segmentos dinámicos.
    // Soporta placeholders '%s' en endpoint.url (p.ej. "/users/%s/posts/%s").
    final raw = _endpoint.url;
    final args = _urlArgs ?? const [];

    final parts = raw.split('/').where((p) => p.isNotEmpty).toList();
    int i = 0;
    final replaced = parts.map((p) {
      if (p == '%s') {
        final val = (i < args.length) ? args[i++] : '';
        return Uri.encodeComponent(val);
      }
      return p;
    }).toList();

    return '/${replaced.join('/')}';
  }

  // ---------- Respuesta y errores ----------
  SOApiResponse _handleResponse(Response response) {
    final code = response.statusCode ?? 500;
    final isSuccess = code >= 200 && code < 300;

    if (code == 204) {
      return SOApiResponse(
        success: true,
        data: null,
        responseCode: code,
        message: 'Operación exitosa',
      );
    }

    final message = isSuccess
        ? 'Operación exitosa'
        : _extractMessage(response.data) ?? 'Ocurrió un error.';

    return SOApiResponse(
      success: isSuccess,
      data: response.data,
      responseCode: code,
      message: message,
    );
  }

  SOApiResponse _handleDioException(DioException e) {
    final code = e.response?.statusCode ?? 0;

    String fallbackByType() {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Tiempo de espera agotado.';
        case DioExceptionType.badCertificate:
          return 'Certificado TLS inválido.';
        case DioExceptionType.badResponse:
          return 'Respuesta inválida del servidor.';
        case DioExceptionType.cancel:
          return 'Solicitud cancelada.';
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
        return 'Error de red o conexión.';
      }
    }

    final responseMsg = _extractMessage(e.response?.data);
    final msg = e.message ?? responseMsg ?? fallbackByType();

    return SOApiResponse(
      success: false,
      responseCode: code == 0 ? 500 : code,
      message: msg,
      data: e.response?.data,
    );
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final msg = data['message'] ?? data['error'] ?? data['detail'];
      return msg?.toString();
    }
    if (data is String) return data;
    return null;
  }
}
