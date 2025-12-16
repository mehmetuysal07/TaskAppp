import 'package:equatable/equatable.dart';
import 'task_status.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final TaskStatus status; // Enum tipi
  final String personel;
  final String? resolutionDescription; // Yapılan iş açıklaması (Opsiyonel)
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.personel,
    this.resolutionDescription,
    required this.createdAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  // Equatable'ın hangi alanlara bakarak eşitlik kontrolü yapacağını belirtiyoruz
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    personel,
    resolutionDescription,
    createdAt,
  ];
}
