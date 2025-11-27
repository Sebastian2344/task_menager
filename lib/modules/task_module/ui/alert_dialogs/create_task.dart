import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 1));

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
        'Dodaj nowe zadanie',style: TextStyle(fontWeight: FontWeight.bold),
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
                    labelText: "Nazwa zadania",
                    filled: true,
                    fillColor: Colors.indigo[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Podaj nazwę zadania";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: "Opis (opcjonalny)",
                    filled: true,
                    fillColor: Colors.indigo[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Text(
                  "Termin: ${_deadline.toLocal().toIso8601String().split('.')[0].replaceFirst('T', ' ')}",
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Column(
          spacing: 16,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range, color: Colors.white),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[700],
              ),
              onPressed: () async {
                final now = DateTime.now();
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: now,
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
              label: const Text("Ustaw termin",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await context.read<TaskProvider>().addTask(
                        _titleController.text.trim(),
                        _descController.text.trim().isEmpty
                            ? " "
                            : _descController.text.trim(),
                        _deadline,
                      );
                      if (context.mounted){
                        context.read<StatsProvider>().addTask();
                       Navigator.pop(context);
                       ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Zadanie utworzone')),
                          );
                      }
                    }
                  },
                  label: const Text(
                    "Zapisz",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                  ),
                  onPressed: () => Navigator.pop(context),
                  label: const Text(
                    "Anuluj",
                    style: TextStyle(color: Colors.white),
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
