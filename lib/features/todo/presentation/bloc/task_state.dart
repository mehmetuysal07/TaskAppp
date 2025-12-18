import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/filter_criteria.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

// 1. Başlangıç durumu
class TaskInitial extends TaskState {}

// 2. Yükleniyor durumu (Spinner dönerken)
class TaskLoading extends TaskState {}

// 3. Veriler geldi durumu (Ekranda listeyi gösterirken)
class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final List<TaskEntity> filteredTasks;
  final FilterCriteria filterCriteria;

  const TaskLoaded(
    this.tasks, {
    this.filteredTasks = const [],
    this.filterCriteria = const FilterCriteria(),
  });

  @override
  List<Object> get props => [tasks, filteredTasks, filterCriteria];
}

// 4. Hata durumu (Bir şeyler ters giderse)
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
