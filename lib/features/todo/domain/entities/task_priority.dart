import 'package:hive/hive.dart';

part 'task_priority.g.dart';

@HiveType(typeId: 2) // TaskStatus 1 kullanıyor olabilir, kontrol edeceğim
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Düşük';
      case TaskPriority.medium:
        return 'Orta';
      case TaskPriority.high:
        return 'Yüksek';
    }
  }
}
