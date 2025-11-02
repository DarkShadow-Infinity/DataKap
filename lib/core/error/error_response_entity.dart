import 'package:equatable/equatable.dart';

class ErrorResponseEntity extends Equatable {
  final String detail;

  const ErrorResponseEntity({
    required this.detail,
  });

  @override
  List<Object?> get props => [detail];

  @override
  String toString() => 'ErrorResponseEntity(detail: $detail)';
}
