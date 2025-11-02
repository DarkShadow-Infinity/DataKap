import 'package:equatable/equatable.dart';

class PaginationEntity extends Equatable {
  final int page;
  final int limit;
  final int total;

  const PaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [page, limit, total];

  @override
  String toString() =>
      'PaginationEntity(page: $page, limit: $limit, total: $total)';
}
