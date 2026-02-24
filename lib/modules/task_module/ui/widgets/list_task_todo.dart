import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';

import 'task_todo.dart';

class ListTaskTodo extends StatelessWidget {
  const ListTaskTodo({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<TaskProvider, List<int?>>(
        selector: (context, provider) => provider.upcomingTasksIds,
        builder: (context, tasksId, child) {
          return ListView.builder(
            itemCount: tasksId.length,
            itemBuilder: (context, index) {
              return TaskTodo(taskid: tasksId[index]!);
            },
          );
        },
      ),
    );
  }
}
