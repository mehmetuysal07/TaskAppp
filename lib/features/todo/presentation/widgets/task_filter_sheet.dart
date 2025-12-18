import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/filter_criteria.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../bloc/task_cubit.dart';

class TaskFilterSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;

  const TaskFilterSheet({super.key, required this.initialCriteria});

  @override
  State<TaskFilterSheet> createState() => _TaskFilterSheetState();
}

class _TaskFilterSheetState extends State<TaskFilterSheet> {
  late TextEditingController _searchController;
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialCriteria.query,
    );
    _selectedStatus = widget.initialCriteria.status;
    _selectedPriority = widget.initialCriteria.priority;
    _startDate = widget.initialCriteria.startDate;
    _endDate = widget.initialCriteria.endDate;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final criteria = FilterCriteria(
      query: _searchController.text,
      status: _selectedStatus,
      priority: _selectedPriority,
      startDate: _startDate,
      endDate: _endDate,
    );
    context.read<TaskCubit>().applyFilter(criteria);
    Navigator.pop(context);
  }

  void _clearFilters() {
    context.read<TaskCubit>().applyFilter(const FilterCriteria());
    Navigator.pop(context);
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrele ve Ara',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Ara',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Durum', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: TaskStatus.values.map((status) {
              return FilterChip(
                label: Text(status.displayName),
                selected: _selectedStatus == status,
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? status : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Öncelik', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: TaskPriority.values.map((priority) {
              return FilterChip(
                label: Text(priority.displayName),
                selected: _selectedPriority == priority,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = selected ? priority : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Tarih Aralığı'),
            subtitle: Text(
              _startDate != null && _endDate != null
                  ? '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}'
                  : 'Seçilmedi',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDateRange,
          ),
          const Spacer(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Temizle'),
                ),
                const SizedBox(width: 8), // Butonlar arası boşluk
                ElevatedButton.icon(
                  onPressed: _applyFilters,
                  icon: const Icon(Icons.check),
                  label: const Text('Uygula'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
