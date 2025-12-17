import 'package:equatable/equatable.dart';
import 'task_status.dart';
import 'task_priority.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status; // Enum tipi
  final TaskPriority priority; // Yeni alan
  final String personel;
  final String? resolutionDescription; // Yapılan iş açıklaması (Opsiyonel)
  final DateTime createdAt;
  final DateTime? dueDate; // Yeni alan

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.priority = TaskPriority.medium, // Varsayılan orta
    required this.personel,
    this.resolutionDescription,
    required this.createdAt,
    this.dueDate,
  });

  bool get isCompleted => status == TaskStatus.completed;

  // Equatable'ın hangi alanlara bakarak eşitlik kontrolü yapacağını belirtiyoruz
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    priority,
    personel,
    resolutionDescription,
    createdAt,
    dueDate,
  ];
}
