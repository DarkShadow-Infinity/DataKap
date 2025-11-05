import 'package:equatable/equatable.dart';

class PostalCodeInfoEntity extends Equatable {
  final String estado;
  final String municipio;
  final List<String> asentamientos;

  const PostalCodeInfoEntity({
    required this.estado,
    required this.municipio,
    required this.asentamientos,
  });

  @override
  List<Object?> get props => [estado, municipio, asentamientos];
}
