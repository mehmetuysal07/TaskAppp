import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  // "call" metodu sayesinde sınıfı fonksiyon gibi çağırabiliriz: addTaskUseCase(params)
  Future<Either<Failure, Unit>> call(TaskEntity task) async {
    // İleride buraya iş kuralı ekleyebilirsin.
    // Örnek: "Görev adı boş olamaz" kontrolü UI yerine burada da yapılabilir.
    return await repository.addTask(task);
  }
}
