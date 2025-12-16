import 'package:hive/hive.dart';
import '../model/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel task);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  // Hive kutusunu (tablosunu) temsil eder
  final Box<TaskModel> taskBox;

  TaskLocalDataSourceImpl(this.taskBox);

  @override
  Future<List<TaskModel>> getTasks() async {
    return taskBox.values.toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await taskBox.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    await taskBox.delete(id);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    // Hive'da aynı ID (key) ile put yaparsan update eder
    await taskBox.put(task.id, task);
  }
}
