import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_status.dart';
import '../../domain/entities/task_priority.dart';
import '../bloc/task_cubit.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  final TaskEntity? task;
  const AddTaskDialog({super.key, this.task});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _personelController = TextEditingController();
  final _resolutionController = TextEditingController(); // Yeni alan
  TaskStatus _selectedStatus = TaskStatus.pending; // Varsayılan durum
  TaskPriority _selectedPriority = TaskPriority.medium; // Varsayılan öncelik
  DateTime? _selectedDueDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _personelController.text = widget.task!.personel;
      _selectedStatus = widget.task!.status;
      _selectedPriority = widget.task!.priority;
      _selectedDueDate = widget.task!.dueDate;
      if (widget.task!.resolutionDescription != null) {
        _resolutionController.text = widget.task!.resolutionDescription!;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _personelController.dispose();
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        constraints: const BoxConstraints(maxHeight: 600), // Max yükseklik
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.task == null ? 'Yeni Görev' : 'Görevi Düzenle',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Başlık',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Başlık gerekli'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          labelText: 'Açıklama',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _personelController,
                        decoration: const InputDecoration(
                          labelText: 'Görevli Personel',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Personel gerekli'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<TaskStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Durum',
                          prefixIcon: Icon(Icons.flag),
                        ),
                        items: TaskStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        isExpanded: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<TaskPriority>(
                              value: _selectedPriority,
                              decoration: const InputDecoration(
                                labelText: 'Öncelik',
                                prefixIcon: Icon(Icons.low_priority),
                              ),
                              items: TaskPriority.values.map((priority) {
                                return DropdownMenuItem(
                                  value: priority,
                                  child: Text(
                                    priority.displayName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedPriority = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _selectedDueDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDueDate = date;
                                  });
                                }
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Son Tarih',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _selectedDueDate != null
                                      ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(_selectedDueDate!)
                                      : 'Seçiniz',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _resolutionController,
                        decoration: const InputDecoration(
                          labelText: 'Yapılan İş Açıklaması (Opsiyonel)',
                          prefixIcon: Icon(Icons.check_circle_outline),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final isEditing = widget.task != null;
                      final id = isEditing
                          ? widget.task!.id
                          : DateTime.now().millisecondsSinceEpoch.toString();

                      final updatedTask = TaskEntity(
                        id: id,
                        title: _titleController.text,
                        description: _descController.text,
                        personel: _personelController.text,
                        status: _selectedStatus,
                        priority: _selectedPriority,
                        dueDate: _selectedDueDate,
                        resolutionDescription:
                            _resolutionController.text.isNotEmpty
                            ? _resolutionController.text
                            : null,
                        createdAt: isEditing
                            ? widget.task!.createdAt
                            : DateTime.now(),
                      );

                      if (isEditing) {
                        context.read<TaskCubit>().updateTask(updatedTask);
                      } else {
                        context.read<TaskCubit>().addTask(updatedTask);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.task == null ? 'Oluştur' : 'Güncelle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
