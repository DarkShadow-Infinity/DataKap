import 'package:datakap/core/pagination_entity.dart';

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.page,
    required super.limit,
    required super.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
    };
  }
}
