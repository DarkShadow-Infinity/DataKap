import 'package:equatable/equatable.dart';

class PostalCodeEntity extends Equatable {
  final String estado;
  final String estadoAbreviatura;
  final String municipio;
  final String centroReparto;
  final String codigoPostal;
  final List<String> colonias;

  const PostalCodeEntity({
    required this.estado,
    required this.estadoAbreviatura,
    required this.municipio,
    required this.centroReparto,
    required this.codigoPostal,
    required this.colonias,
  });

  @override
  List<Object?> get props => [
        estado,
        estadoAbreviatura,
        municipio,
        centroReparto,
        codigoPostal,
        colonias,
      ];

  @override
  String toString() =>
      'PostalCodeEntity(estado: $estado, estadoAbreviatura: $estadoAbreviatura, municipio: $municipio, centroReparto: $centroReparto, codigoPostal: $codigoPostal, colonias: $colonias)';
}
