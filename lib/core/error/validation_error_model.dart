import 'package:datakap/core/error/validation_error_entity.dart';

class ValidationErrorModel extends ValidationErrorEntity {
  const ValidationErrorModel({
    required super.type,
    required super.loc,
    required super.msg,
    required super.input,
    super.ctx,
  });

  factory ValidationErrorModel.fromJson(Map<String, dynamic> json) {
    return ValidationErrorModel(
      type: json['type'] as String,
      loc: List<String>.from(json['loc'] as List),
      msg: json['msg'] as String,
      input: json['input'],
      ctx: json['ctx'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'loc': loc,
      'msg': msg,
      'input': input,
      'ctx': ctx,
    };
  }
}
