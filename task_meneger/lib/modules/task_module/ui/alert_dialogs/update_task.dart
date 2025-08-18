import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/shared/model/task.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';

class UpdateTask extends StatefulWidget {
  final Task task;

  const UpdateTask({super.key, required this.task});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _deadline = widget.task.deadline;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigo[200],
      title: const Text(
        'Edytuj zadanie',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    fillColor: Colors.indigo[100],
                    labelText: "Nazwa zadania",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.title, color: Colors.indigo[800]),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Podaj nazwę zadania";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    fillColor: Colors.indigo[100],
                    labelText: "Opis (opcjonalny)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.description, color: Colors.indigo[800]),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  _deadline == null
                      ? "Brak daty"
                      : "Termin: ${_deadline!.toLocal().toIso8601String().split('.')[0].replaceFirst('T', ' ')}",
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async { 
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _deadline ?? now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 5),
                );
                if (!context.mounted || pickedDate == null) return;
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime == null) return;
                setState(() {
                  _deadline = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
              icon: Icon(Icons.calendar_today),
              label: Text("Ustaw termin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(  
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<TaskProvider>().updateTasks(
                          widget.task.id!,
                          _titleController.text.trim(),
                          _descController.text.trim().isEmpty
                              ? " "
                              : _descController.text.trim(),
                          _deadline ?? widget.task.deadline,
                          widget.task.realisationDate,
                        );
                        if (context.mounted){
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Zadanie zaktualizowane')),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text("Zapisz"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.cancel),
                    label: Text("Anuluj"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
