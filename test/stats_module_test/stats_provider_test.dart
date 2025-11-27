import 'package:flutter_test/flutter_test.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/shared/model/task.dart';

void main() {

  late StatsProvider statsProvider;

  setUp(() {
    statsProvider = StatsProvider();
  });
  test('Stats after init', () {
    expect(statsProvider.completed, 0);
    expect(statsProvider.pending, 0);
    expect(statsProvider.maxTasksInWeekday, 0);
    expect(statsProvider.productiveWeekday, null);
    statsProvider.statsInit(completedTasks: [], upcomingTasksCount: 5);
    expect(statsProvider.completed, 0);
    expect(statsProvider.pending, 5);
    expect(statsProvider.maxTasksInWeekday, 0);
    expect(statsProvider.productiveWeekday, null);
  });

  test('Add task', () {
    statsProvider.addTask();
    expect(statsProvider.pending, 1);
    statsProvider.addTask();
    expect(statsProvider.pending, 2);
  });

  test('Remove task', () {
    statsProvider.statsInit(completedTasks: [], upcomingTasksCount: 5);
    expect(statsProvider.pending, 5);
    statsProvider.removeTask(Task(title: 'l',deadline: DateTime.now(),isCompleted: false));
    expect(statsProvider.pending, 4);
  });

  test('Update task status complete and uncomplete', () {
    statsProvider.statsInit(completedTasks: [], upcomingTasksCount: 5);
    expect(statsProvider.pending, 5);
    expect(statsProvider.completed, 0);
    statsProvider.updateTaskStatus(Task(title: 'l',deadline: DateTime.now(),isCompleted: true,realisationDate: DateTime.now()));
    expect(statsProvider.pending, 4);
    expect(statsProvider.completed, 1);
    statsProvider.updateTaskStatus(Task(title: 'l',deadline: DateTime.now(),isCompleted: false,realisationDate: DateTime.now()));
    expect(statsProvider.pending, 5);
    expect(statsProvider.completed, 0);
  });
}