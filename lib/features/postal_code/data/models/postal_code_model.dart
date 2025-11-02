import 'package:datakap/features/postal_code/domain/entities/postal_code_entity.dart';

class PostalCodeModel extends PostalCodeEntity {
  const PostalCodeModel({
    required super.estado,
    required super.estadoAbreviatura,
    required super.municipio,
    required super.centroReparto,
    required super.codigoPostal,
    required super.colonias,
  });

  factory PostalCodeModel.fromJson(Map<String, dynamic> json) {
    return PostalCodeModel(
      estado: json['estado'] as String,
      estadoAbreviatura: json['estado_abreviatura'] as String,
      municipio: json['municipio'] as String,
      centroReparto: json['centro_reparto'] as String,
      codigoPostal: json['codigo_postal'] as String,
      colonias: List<String>.from(json['colonias'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estado': estado,
      'estado_abreviatura': estadoAbreviatura,
      'municipio': municipio,
      'centro_reparto': centroReparto,
      'codigo_postal': codigoPostal,
      'colonias': colonias,
    };
  }
}
