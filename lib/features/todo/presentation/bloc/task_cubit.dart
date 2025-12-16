import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/get_tasks.dart';
import 'task_state.dart';

// İhtiyaca göre DeleteTask ve UpdateTask usecase'lerini de buraya import etmelisin

import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/update_task.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;

  TaskCubit({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.deleteTaskUseCase,
    required this.updateTaskUseCase,
  }) : super(TaskInitial());

  // Görevleri veritabanından getir
  Future<void> loadTasks() async {
    emit(TaskLoading());

    // UseCase'i çağırıyoruz (Parametre yoksa genelde NoParams kullanılır veya boş bırakılır)
    final result = await getTasksUseCase();

    result.fold(
      (failure) => emit(TaskError(_mapFailureToMessage(failure))),
      (tasks) => emit(TaskLoaded(tasks)),
    );
  }

  // Görev sil
  Future<void> deleteTask(String id) async {
    // Silme işlemi sırasında loading gösterebiliriz
    // emit(TaskLoading()); // İsteğe bağlı, ekran titremesin diye kapalı tutabiliriz

    final result = await deleteTaskUseCase(id);

    result.fold((failure) => emit(TaskError(_mapFailureToMessage(failure))), (
      unit,
    ) {
      // Silme başarılı, listeyi yenile
      loadTasks();
    });
  }

  // Görev güncelle
  Future<void> updateTask(TaskEntity task) async {
    // emit(TaskLoading());

    final result = await updateTaskUseCase(task);

    result.fold((failure) => emit(TaskError(_mapFailureToMessage(failure))), (
      unit,
    ) {
      // Güncelleme başarılı, listeyi yenile
      loadTasks();
    });
  }

  // Yeni görev ekle
  Future<void> addTask(TaskEntity task) async {
    // Ekleme yaparken loading gösterebiliriz veya göstermeden arkada yapabiliriz.
    // Basit olması için loading gösterip listeyi yenileyelim.
    emit(TaskLoading());

    final result = await addTaskUseCase(task);

    result.fold((failure) => emit(TaskError(_mapFailureToMessage(failure))), (
      unit,
    ) {
      // Ekleme başarılıysa listeyi tekrar çekip güncel hali gösterelim
      loadTasks();
    });
  }

  // Hata mesajlarını kullanıcı dostu metne çevirme
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Sunucu hatası oluştu';
      case CacheFailure _: // Yerel veritabanı hatası
        return 'Veritabanı hatası oluştu';
      default:
        return 'Beklenmedik bir hata';
    }
  }
}
