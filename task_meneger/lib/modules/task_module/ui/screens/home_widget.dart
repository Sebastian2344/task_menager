import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/task_module/ui/alert_dialogs/create_task.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/list_task_done.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/list_task_todo.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              showDialog(context: context, builder: (context) => CreateTask());
            },
            label: const Text(
              'Dodaj zadanie',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sort, color: Colors.white),
                label: const Text('Segreguj wg terminu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<TaskProvider>().sortTasksByDeadline();
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
              const Text(
                'Zadania do wykonania',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Icon(Icons.pending_actions, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 8),
          ListTaskTodo(),
          const SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
              const Text(
                'Zadania wykonane',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const SizedBox(height: 8),
          ListTaskDone(),
        ],
      ),
    );
  }
}
