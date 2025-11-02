import 'package:datakap/features/admin_user_management/domain/entities/dashboard_summary_registration_count_entity.dart';

class DashboardSummaryRegistrationCountModel extends DashboardSummaryRegistrationCountEntity {
  const DashboardSummaryRegistrationCountModel({
    required super.today,
    required super.thisWeek,
    required super.thisMonth,
  });

  factory DashboardSummaryRegistrationCountModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryRegistrationCountModel(
      today: json['today'] as int,
      thisWeek: json['thisWeek'] as int,
      thisMonth: json['thisMonth'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
    };
  }
}
