import 'package:datakap/features/catalogs/domain/entities/catalog_locations_entity.dart';

class CatalogLocationsModel extends CatalogLocationsEntity {
  const CatalogLocationsModel({
    required super.states,
    required super.municipalities,
    required super.localities,
  });

  factory CatalogLocationsModel.fromJson(Map<String, dynamic> json) {
    return CatalogLocationsModel(
      states: List<String>.from(json['states'] as List),
      municipalities: List<String>.from(json['municipalities'] as List),
      localities: List<String>.from(json['localities'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'states': states,
      'municipalities': municipalities,
      'localities': localities,
    };
  }
}
