import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// 🚀 Interceptor para registrar solicitudes, respuestas y errores HTTP en consola.
/// Utiliza el paquete `logger` para una salida estructurada, con colores y niveles.
class RequestInterceptor extends Interceptor {
  // Instancia del logger.
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // No mostrar el stack trace de la llamada al logger
      errorMethodCount: 8, // Mostrar 8 lineas de stack trace para errores
      lineLength: 120, // Ancho de la línea
      colors: true, // Colores en la consola
      printEmojis: true, // Imprimir emojis
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  /// 🔄 Intercepta y registra cada solicitud antes de ser enviada.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      logger.i('📤 [REQUEST] ${options.method} ${options.uri}');
      logger.d('📦 Headers:\n${jsonEncode(options.headers)}');
      if (options.data != null) {
        try {
          final body = const JsonEncoder.withIndent('  ').convert(options.data);
          logger.d('📝 Body:\n$body');
        } catch (_) {
          logger.d('📝 Body (raw): ${options.data}');
        }
      }
    }
    handler.next(options);
  }

  /// ✅ Intercepta y registra cada respuesta recibida.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      logger.i(
        '📥 [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
      );
      try {
        final json = const JsonEncoder.withIndent('  ').convert(response.data);
        logger.d('📄 Data:\n$json');
      } catch (_) {
        logger.d('📄 Data (raw): ${response.data}');
      }
    }
    handler.next(response);
  }

  /// ❌ Intercepta y registra errores en la solicitud HTTP.
  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logger.e(
        '❌ [ERROR] ${e.response?.statusCode} ${e.requestOptions.uri}',
        error: e,
        stackTrace: e.stackTrace,
      );
    }
    handler.next(e);
  }
}
