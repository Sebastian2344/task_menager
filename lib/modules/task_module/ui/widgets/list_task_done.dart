import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/task_done.dart';

class ListTaskDone extends StatelessWidget {
  const ListTaskDone({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().completedTasks;
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {      
          return TaskDone(task:tasks[index]);
        },
      ),
    );
  }
}
