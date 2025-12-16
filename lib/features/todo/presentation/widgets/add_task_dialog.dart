import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/task_status.dart';
import '../bloc/task_cubit.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _personelController = TextEditingController();
  final _resolutionController = TextEditingController(); // Yeni alan
  TaskStatus _selectedStatus = TaskStatus.pending; // Varsayılan durum
  final _formKey = GlobalKey<FormState>();

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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Yeni Görev',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Başlık',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Başlık gerekli' : null,
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
                  // value parametresi form alanlarında bazen sorun çıkarabiliyor veya deprecated olabiliyor.
                  // Ancak state yönetimi için value kullanmak genellikle daha doğrudur.
                  // Eğer uyarı alıyorsanız ve ignore etmek istiyorsanız:
                  // ignore: deprecated_member_use
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Durum',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
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
                const SizedBox(height: 24),
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
                          final id = DateTime.now().millisecondsSinceEpoch
                              .toString();

                          final newTask = TaskEntity(
                            id: id,
                            title: _titleController.text,
                            description: _descController.text,
                            personel: _personelController.text,
                            status: _selectedStatus, // Seçilen durum
                            resolutionDescription:
                                _resolutionController.text.isNotEmpty
                                ? _resolutionController.text
                                : null,
                            createdAt: DateTime.now(),
                          );

                          context.read<TaskCubit>().addTask(newTask);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Oluştur'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
