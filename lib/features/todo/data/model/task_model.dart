import 'package:hive/hive.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_status.dart';

// Bu dosya otomatik oluşturulacak
part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String personel;
  @HiveField(4)
  final TaskStatus status; // isCompleted yerine status geldi
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final String? resolutionDescription; // Yeni alan

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.personel,
    required this.status,
    required this.createdAt,
    this.resolutionDescription,
  });

  // Entity'den Model'e çevirme
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      personel: entity.personel,
      status: entity.status, // Direkt enum geçişi
      resolutionDescription: entity.resolutionDescription,
      createdAt: entity.createdAt,
    );
  }

  // Model'den Entity'ye çevirme
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      personel: personel,
      status: status,
      resolutionDescription: resolutionDescription,
      createdAt: createdAt,
    );
  }
}
