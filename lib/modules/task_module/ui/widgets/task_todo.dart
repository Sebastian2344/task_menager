import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/shared/model/task.dart';

import '../alert_dialogs/update_task.dart';

class TaskTodo extends StatelessWidget {
  final int taskid;
  const TaskTodo({super.key, required this.taskid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final task = provider.upcomingTasks.firstWhere(
            (t) => t.id == taskid,
          );
          return _buildTaskCard(context, task);
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white, size: 36),
      ),
      onDismissed: (direction) async {
        await context.read<TaskProvider>().removeTask(task);
        if (context.mounted) {
          context.read<StatsProvider>().removeTask(task);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usunięto zadanie do wykonania')),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          tileColor: Colors.blue[100],
          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(task.description ?? 'Brak opisu', style: const TextStyle(color: Colors.blue)),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('Termin: ${task.deadline.toLocal().toString().split('.')[0]}', style: const TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          onTap: () {
            showDialog(context: context, builder: (context) => UpdateTask(task: task));
          },
          trailing: Checkbox(
            activeColor: Colors.blue,
            value: task.isCompleted,
            onChanged: (value) async {
              await context.read<TaskProvider>().realisionTask(task, value!);
              if (context.mounted) {
                context.read<StatsProvider>().updateTaskStatus(
                      context.read<TaskProvider>().upcomingTasks.firstWhere((e) => e.id == task.id),
                    );
              }
            },
          ),
        ),
      ),
    );
  }
}