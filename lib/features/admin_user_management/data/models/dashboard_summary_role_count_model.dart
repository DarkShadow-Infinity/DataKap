import 'package:datakap/features/admin_user_management/domain/entities/dashboard_summary_role_count_entity.dart';

class DashboardSummaryRoleCountModel extends DashboardSummaryRoleCountEntity {
  const DashboardSummaryRoleCountModel({
    required super.active,
    required super.pending,
    required super.rejected,
  });

  factory DashboardSummaryRoleCountModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryRoleCountModel(
      active: json['active'] as int,
      pending: json['pending'] as int,
      rejected: json['rejected'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'pending': pending,
      'rejected': rejected,
    };
  }
}
