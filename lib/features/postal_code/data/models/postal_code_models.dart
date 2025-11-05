import 'package:datakap/features/postal_code/domain/entities/postal_code_info_entity.dart';

class PostalCodeInfoModel extends PostalCodeInfoEntity {
  const PostalCodeInfoModel({
    required String estado,
    required String municipio,
    required List<String> asentamientos,
  }) : super(estado: estado, municipio: municipio, asentamientos: asentamientos);

  factory PostalCodeInfoModel.fromJson(Map<String, dynamic> json) {
    final postalCodeData = json['codigo_postal'] as Map<String, dynamic>? ?? {};
    final asentamientosList = (postalCodeData['colonias'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return PostalCodeInfoModel(
      estado: postalCodeData['estado'] as String? ?? '',
      municipio: postalCodeData['municipio'] as String? ?? '',
      asentamientos: asentamientosList,
    );
  }
}
