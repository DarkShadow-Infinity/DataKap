import 'package:equatable/equatable.dart';
import 'package:datakap/features/admin_user_management/domain/entities/dashboard_summary_role_count_entity.dart';
import 'package:datakap/features/admin_user_management/domain/entities/dashboard_summary_registration_count_entity.dart';

class DashboardSummaryEntity extends Equatable {
  final DashboardSummaryRoleCountEntity promoters;
  final DashboardSummaryRoleCountEntity leaders;
  final DashboardSummaryRegistrationCountEntity registrations;
  final String apiVersion;

  const DashboardSummaryEntity({
    required this.promoters,
    required this.leaders,
    required this.registrations,
    required this.apiVersion,
  });

  @override
  List<Object?> get props =>
      [promoters, leaders, registrations, apiVersion];

  @override
  String toString() =>
      'DashboardSummaryEntity(promoters: $promoters, leaders: $leaders, registrations: $registrations, apiVersion: $apiVersion)';
}
