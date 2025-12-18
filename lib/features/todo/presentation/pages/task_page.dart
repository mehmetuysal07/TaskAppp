import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_cubit.dart';
import '../bloc/task_state.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_item.dart';
import '../widgets/task_filter_sheet.dart';
import 'statistics_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacaklar'),
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'İstatistikler',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<TaskCubit>(),
                    child: const StatisticsPage(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrele',
            onPressed: () {
              final state = context.read<TaskCubit>().state;
              if (state is TaskLoaded) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => BlocProvider.value(
                    value: context.read<TaskCubit>(),
                    child: TaskFilterSheet(
                      initialCriteria: state.filterCriteria,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt, // veya Icons.list_alt
                      size: 100,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Henüz bir görev yok",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Artı butonuna basarak yeni görev ekleyin.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            } else if (state.filteredTasks.isEmpty) {
              return const Center(
                child: Text(
                  "Aradığınız kriterlere uygun görev bulunamadı.",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            // Listeyi gösteriyoruz
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.filteredTasks.length,
              itemBuilder: (context, index) {
                final task = state.filteredTasks[index];
                return TaskItem(task: task);
              },
            );
          } else if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => context.read<TaskCubit>().loadTasks(),
                    child: const Text("Tekrar Dene"),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ekleme Dialog'unu aç
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context
                  .read<TaskCubit>(), // Mevcut Cubit'i Dialog'a taşıyoruz
              child: const AddTaskDialog(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni Görev'),
      ),
    );
  }
}
