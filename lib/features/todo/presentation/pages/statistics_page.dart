import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_status.dart';
import '../bloc/task_cubit.dart';
import '../bloc/task_state.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final tasks = state.tasks;
            final totalTasks = tasks.length;
            final completedTasks = tasks
                .where((t) => t.status == TaskStatus.completed)
                .length;
            final pendingTasks = totalTasks - completedTasks;

            if (totalTasks == 0) {
              return const Center(child: Text("Henüz veri yok"));
            }

            final statusCounts = <TaskStatus, int>{};
            for (var task in tasks) {
              statusCounts[task.status] = (statusCounts[task.status] ?? 0) + 1;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Toplam',
                          count: totalTasks,
                          color: Colors.blue,
                          icon: Icons.list,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Tamamlanan',
                          count: completedTasks,
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Bekleyen',
                          count: pendingTasks,
                          color: Colors.orange,
                          icon: Icons.pending,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Durum Dağılımı",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: statusCounts.entries.map((entry) {
                          final status = entry.key;
                          final count = entry.value;
                          return PieChartSectionData(
                            color: _getStatusColor(status),
                            value: count.toDouble(),
                            title: '$count',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: statusCounts.keys.map((status) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(status.displayName),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text("Veri yüklenemedi"));
        },
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.met:
        return Colors.blue.shade200;
      case TaskStatus.analyzing:
        return Colors.blue;
      case TaskStatus.waitingForDev:
        return Colors.orange.shade300;
      case TaskStatus.inDev:
        return Colors.orange;
      case TaskStatus.testing:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              "$count",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
