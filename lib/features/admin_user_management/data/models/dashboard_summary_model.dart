import 'package:datakap/features/admin_user_management/domain/entities/dashboard_summary_entity.dart';
import 'package:datakap/features/admin_user_management/data/models/dashboard_summary_role_count_model.dart';
import 'package:datakap/features/admin_user_management/data/models/dashboard_summary_registration_count_model.dart';

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.promoters,
    required super.leaders,
    required super.registrations,
    required super.apiVersion,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      promoters: DashboardSummaryRoleCountModel.fromJson(
          json['promoters'] as Map<String, dynamic>),
      leaders: DashboardSummaryRoleCountModel.fromJson(
          json['leaders'] as Map<String, dynamic>),
      registrations: DashboardSummaryRegistrationCountModel.fromJson(
          json['registrations'] as Map<String, dynamic>),
      apiVersion: json['apiVersion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promoters': (promoters as DashboardSummaryRoleCountModel).toJson(),
      'leaders': (leaders as DashboardSummaryRoleCountModel).toJson(),
      'registrations':
          (registrations as DashboardSummaryRegistrationCountModel).toJson(),
      'apiVersion': apiVersion,
    };
  }
}
