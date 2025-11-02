import 'package:equatable/equatable.dart';

class DashboardSummaryRoleCountEntity extends Equatable {
  final int active;
  final int pending;
  final int rejected;

  const DashboardSummaryRoleCountEntity({
    required this.active,
    required this.pending,
    required this.rejected,
  });

  @override
  List<Object?> get props => [active, pending, rejected];

  @override
  String toString() =>
      'DashboardSummaryRoleCountEntity(active: $active, pending: $pending, rejected: $rejected)';
}
