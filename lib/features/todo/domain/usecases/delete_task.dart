import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteTask(id);
  }
}
