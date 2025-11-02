import 'package:equatable/equatable.dart';

class DashboardSummaryRegistrationCountEntity extends Equatable {
  final int today;
  final int thisWeek;
  final int thisMonth;

  const DashboardSummaryRegistrationCountEntity({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  @override
  List<Object?> get props => [today, thisWeek, thisMonth];

  @override
  String toString() =>
      'DashboardSummaryRegistrationCountEntity(today: $today, thisWeek: $thisWeek, thisMonth: $thisMonth)';
}
