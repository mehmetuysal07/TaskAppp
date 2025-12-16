import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'features/todo/data/datasources/task_local_data_source.dart';
import 'features/todo/data/model/task_model.dart';
import 'features/todo/data/repositories/task_repository_impl.dart';
import 'features/todo/domain/repositories/task_repository.dart';
import 'features/todo/domain/usecases/add_task.dart';
import 'features/todo/domain/usecases/delete_task.dart';
import 'features/todo/domain/usecases/get_tasks.dart';
import 'features/todo/domain/usecases/update_task.dart';
import 'features/todo/presentation/bloc/task_cubit.dart';
// Henüz Cubit yazmadık ama yerini hazırlayalım (Yorum satırında)
// import 'features/todo/presentation/bloc/task_cubit.dart';

final sl = GetIt.instance; // sl: Service Locator kısaltması

Future<void> init() async {
  //! Features - Todo
  // Bloc / Cubit (Factory: Çünkü ekran kapanıp açılınca state sıfırlanmalı)
  // sl.registerFactory(() => TaskCubit(getTasks: sl(), addTask: sl()));

  // Use Cases (Singleton)
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));

  // Repository (Singleton)
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl()),
    // sl() diyerek Data Source'u otomatik içine enjekte ediyoruz
  );

  // Data Source (Singleton)
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sl()),
    // sl() diyerek Hive Box'ı otomatik içine enjekte ediyoruz
  );
  sl.registerFactory(
    () => TaskCubit(
      getTasksUseCase: sl(), // sl() otomatik olarak GetTasksUseCase'i bulur
      addTaskUseCase: sl(), // sl() otomatik olarak AddTaskUseCase'i bulur
      deleteTaskUseCase: sl(),
      updateTaskUseCase: sl(),
    ),
  );
  //! External (Dış Bağımlılıklar)
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  sl.registerLazySingleton(() => taskBox);
}
