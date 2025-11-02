import 'package:equatable/equatable.dart';

class CatalogLocationsEntity extends Equatable {
  final List<String> states;
  final List<String> municipalities;
  final List<String> localities;

  const CatalogLocationsEntity({
    required this.states,
    required this.municipalities,
    required this.localities,
  });

  @override
  List<Object?> get props => [states, municipalities, localities];

  @override
  String toString() =>
      'CatalogLocationsEntity(states: $states, municipalities: $municipalities, localities: $localities)';
}
