import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/todo/data/model/task_model.dart'; // Corrected path
import 'features/todo/domain/entities/task_status.dart';
import 'features/todo/domain/entities/task_priority.dart';
import 'features/todo/presentation/bloc/task_cubit.dart';
import 'features/todo/presentation/pages/task_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register Adapter usually requires the generated adapter class.
  // TaskModelAdapter is generated in task_model.g.dart, part of task_model.dart
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Task App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          secondary: Colors.teal,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.withValues(alpha: 0.05),
        ),
      ),
      // BlocProvider, Cubit'i tüm alt widget'lara sağlar
      home: BlocProvider(
        create: (context) => di.sl<TaskCubit>()..loadTasks(),
        child: const TaskPage(),
      ),
    );
  }
}
