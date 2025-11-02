import 'package:equatable/equatable.dart';

class ValidationErrorEntity extends Equatable {
  final String type;
  final List<String> loc;
  final String msg;
  final dynamic input;
  final Map<String, dynamic>? ctx;

  const ValidationErrorEntity({
    required this.type,
    required this.loc,
    required this.msg,
    required this.input,
    this.ctx,
  });

  @override
  List<Object?> get props => [type, loc, msg, input, ctx];

  @override
  String toString() =>
      'ValidationErrorEntity(type: $type, loc: $loc, msg: $msg, input: $input, ctx: $ctx)';
}
