/// Modelo de datos estándar para todas las respuestas de la API.
///
/// Esta clase unifica la estructura de la respuesta, facilitando su manejo
/// en toda la aplicación. Ayuda a saber de antemano si una petición fue
/// exitosa y a obtener un mensaje y los datos asociados.
class SOApiResponse {
  /// Indica si la petición fue exitosa (e.g., código 2xx).
  final bool success;

  /// Mensaje descriptivo sobre el resultado de la operación.
  /// Puede ser un mensaje de éxito o de error.
  final String message;

  /// Los datos reales devueltos por la API.
  ///
  /// Puede ser un mapa, una lista o cualquier otro tipo de dato. Es dinámico
  /// para permitir flexibilidad, pero debe ser casteado a un modelo específico
  /// en la capa del repositorio.
  final dynamic data;

  /// El código de estado HTTP de la respuesta (e.g., 200, 404, 500).
  final int responseCode;

  SOApiResponse({
    required this.success,
    this.message = '',
    this.data,
    this.responseCode = -1,
  });

  /// Constructor de fábrica para crear una respuesta a partir de un JSON.
  factory SOApiResponse.fromJson(Map<String, dynamic> json) {
    return SOApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      // Asumimos que el código de respuesta no viene en el JSON,
      // sino que se asigna al construir la respuesta.
    );
  }
}
