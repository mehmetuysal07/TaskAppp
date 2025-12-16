import 'package:hive/hive.dart';

part 'task_status.g.dart';

@HiveType(typeId: 1) // TaskModel typeId: 0, buna 1 veriyoruz
enum TaskStatus {
  @HiveField(0)
  pending, // Bekliyor
  @HiveField(1)
  met, // Karşılandı
  @HiveField(2)
  analyzing, // Analiz Ediliyor
  @HiveField(3)
  waitingForDev, // Yazılım Geliştirme Bekliyor
  @HiveField(4)
  inDev, // Yazılım Geliştirmede
  @HiveField(5)
  testing, // Test Ediliyor
  @HiveField(6)
  completed, // Sonuçlandı
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Bekliyor';
      case TaskStatus.met:
        return 'Karşılandı';
      case TaskStatus.analyzing:
        return 'Analiz Ediliyor';
      case TaskStatus.waitingForDev:
        return 'Yazılım Geliştirme Bekliyor';
      case TaskStatus.inDev:
        return 'Yazılım Geliştirmede';
      case TaskStatus.testing:
        return 'Test Ediliyor';
      case TaskStatus.completed:
        return 'Sonuçlandı';
    }
  }
}
