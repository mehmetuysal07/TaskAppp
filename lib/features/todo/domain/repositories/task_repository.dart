import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  // Tüm görevleri getir
  Future<Either<Failure, List<TaskEntity>>> getTasks();

  // Yeni görev ekle (Başarılı olursa Unit döner - void'in fpdart karşılığı)
  Future<Either<Failure, Unit>> addTask(TaskEntity task);

  // Görevi sil
  Future<Either<Failure, Unit>> deleteTask(String id);

  // Görevi güncelle (tamamlandı/tamamlanmadı)
  Future<Either<Failure, Unit>> updateTask(TaskEntity task);
}
