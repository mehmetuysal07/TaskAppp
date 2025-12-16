import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

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

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

// 4. Hata durumu (Bir şeyler ters giderse)
class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
