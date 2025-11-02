import 'package:datakap/core/error/error_response_entity.dart';

class ErrorResponseModel extends ErrorResponseEntity {
  const ErrorResponseModel({
    required super.detail,
  });

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      detail: json['detail'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
    };
  }
}
