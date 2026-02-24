import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';

class TaskDone extends StatelessWidget {
  final int index;
  const TaskDone({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final task = context.read<TaskProvider>().completedTasks[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Dismissible(
        key: ValueKey(task.id),
        background: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.red),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white, size: 36),
        ),
        onDismissed: (direction) async {
          await context.read<TaskProvider>().removeTask(task);
          if (context.mounted) {
            context.read<StatsProvider>().removeTask(task);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usunięto wykonane zadanie')),
            );
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: ListTile(
            tileColor: Colors.green[100],
            title: Text(
              task.title,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.green,
              ),
            ),
            subtitle: Column(
              children: [
                Text(
                  task.description ?? 'Brak opisu',
                  style: const TextStyle(color: Colors.green),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Wykonano: ${task.realisationDate?.toLocal().toString().split('.')[0]}',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            trailing: Checkbox(
              activeColor: Colors.green,
              value: task.isCompleted,
              onChanged: (bool? value) async {
                await context.read<TaskProvider>().realisionTask(task, value!);
                if (context.mounted) {
                  context.read<StatsProvider>().updateTaskStatus(
                    context
                        .read<TaskProvider>()
                        .upcomingTasks
                        .firstWhere((element) => element.id == task.id)
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
