import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/screens/home_widget.dart';

class GetTasks extends StatefulWidget {
  const GetTasks({super.key});

  @override
  State<GetTasks> createState() => _GetTasksState();
}

class _GetTasksState extends State<GetTasks> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final statsProvider = context.read<StatsProvider>();
      final taskProvider = context.read<TaskProvider>();
      await context.read<TaskProvider>().getTasks();
      statsProvider.statsInit(
        completedTasks: taskProvider.completedTasks,
        upcomingTasksCount: taskProvider.upcomingTasks.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomeWidget();
  }
}