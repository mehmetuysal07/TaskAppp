import 'package:equatable/equatable.dart';
import 'task_status.dart';
import 'task_priority.dart';

class FilterCriteria extends Equatable {
  final String query;
  final TaskStatus? status;
  final TaskPriority? priority;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterCriteria({
    this.query = '',
    this.status,
    this.priority,
    this.startDate,
    this.endDate,
  });

  bool get isEmpty =>
      query.isEmpty &&
      status == null &&
      priority == null &&
      startDate == null &&
      endDate == null;

  FilterCriteria copyWith({
    String? query,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FilterCriteria(
      query: query ?? this.query,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [query, status, priority, startDate, endDate];
}
