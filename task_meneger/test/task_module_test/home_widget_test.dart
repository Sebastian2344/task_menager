import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/screens/home_widget.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/list_task_done.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/list_task_todo.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/task_done.dart';
import 'package:task_meneger/modules/task_module/ui/widgets/task_todo.dart';
import 'package:task_meneger/shared/model/task.dart';

class MockTaskProvider extends Mock implements TaskProvider {}
class MockStatsProvider extends Mock implements StatsProvider {}
void main() {
  late MockTaskProvider mockTaskProvider;
  late MockStatsProvider mockStatsProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
    mockStatsProvider = MockStatsProvider();
  });

  testWidgets('HomeWidget displays buttons and calls sort on tap', (
    tester,
  ) async {
    when(() => mockTaskProvider.upcomingTasksIds).thenReturn([]);
    when(() => mockTaskProvider.completedTasks).thenReturn([]);

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: mockTaskProvider,
        child: const MaterialApp(home: HomeWidget()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dodaj zadanie'), findsOneWidget);

    expect(find.text('Segreguj wg terminu'), findsOneWidget);
    await tester.tap(find.text('Segreguj wg terminu'));
    await tester.pumpAndSettle();

    verify(() => mockTaskProvider.sortTasksByDeadline()).called(1);
  });

  testWidgets('HomeWidget displays lists with items', (tester) async {
    when(() => mockTaskProvider.upcomingTasksIds).thenReturn([1]);
    when(() => mockTaskProvider.completedTasks).thenReturn([
      Task(title: 'title', deadline: DateTime(2026), isCompleted: true),
    ]);
    when(() => mockTaskProvider.upcomingTasks).thenReturn([
      Task(id:1,title: 'title2', deadline: DateTime(2027), isCompleted: false),
    ]);

    await tester.pumpWidget(
      ChangeNotifierProvider<TaskProvider>.value(
        value: mockTaskProvider,
        child: const MaterialApp(home: HomeWidget()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Zadania do wykonania'), findsOneWidget);
    expect(find.byType(ListTaskTodo), findsOneWidget);
    expect(find.text('Zadania wykonane'), findsOneWidget);
    expect(find.byType(ListTaskDone), findsOneWidget);

    expect(find.byType(TaskTodo), findsOneWidget);
    expect(find.byType(TaskDone), findsOneWidget);

    final taskdone = tester.widget<TaskDone>(find.byType(TaskDone));
    expect(taskdone.task.title, 'title');
    expect(taskdone.task.deadline, DateTime(2026));
    expect(taskdone.task.isCompleted, true);

    final tasktodo = tester.widget<TaskTodo>(find.byType(TaskTodo));
    expect(tasktodo.taskid, 1);

    expect(find.textContaining(DateTime(2027).toLocal().toString().split('.')[0]), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox).last).value, true);
  });

  testWidgets('delete task todo triggers removeTask and shows snackbar', (tester) async {
  
  final task = Task(id: 1, title: 'title2', deadline: DateTime(2027), isCompleted: false);
  when(() => mockTaskProvider.upcomingTasksIds).thenReturn([1]);
  when(() => mockTaskProvider.completedTasks).thenReturn([]);
  when(() => mockTaskProvider.upcomingTasks).thenReturn([task]);

  when(() => mockTaskProvider.removeTask(task)).thenAnswer((_) async {});
  when(() => mockStatsProvider.removeTask(task)).thenReturn(null);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
        ChangeNotifierProvider<StatsProvider>.value(value: mockStatsProvider),
      ],
      child: const MaterialApp(home: Scaffold(body: HomeWidget())),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.byType(ListTaskTodo), findsOneWidget);
  final taskFinder = find.byType(TaskTodo);
  expect(taskFinder, findsOneWidget);

  await tester.pumpAndSettle();

  await tester.drag(taskFinder, const Offset(-400, 0));
  await tester.pumpAndSettle();

  verify(() => mockTaskProvider.removeTask(task)).called(1);
  verify(() => mockStatsProvider.removeTask(task)).called(1);

  await tester.pump(const Duration(milliseconds: 200));
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Usunięto zadanie do wykonania'), findsOneWidget);
});

testWidgets('delete task complited triggers removeTask and shows snackbar', (tester) async {
  
  final task = Task(id: 1, title: 'title2', deadline: DateTime(2027), isCompleted: false);
  when(() => mockTaskProvider.upcomingTasksIds).thenReturn([]);
  when(() => mockTaskProvider.completedTasks).thenReturn([task]);
  when(() => mockTaskProvider.upcomingTasks).thenReturn([]);

  when(() => mockTaskProvider.removeTask(task)).thenAnswer((_) async {});
  when(() => mockStatsProvider.removeTask(task)).thenReturn(null);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
        ChangeNotifierProvider<StatsProvider>.value(value: mockStatsProvider),
      ],
      child: const MaterialApp(home: Scaffold(body: HomeWidget())),
    ),
  );

  await tester.pumpAndSettle();

  expect(find.byType(ListTaskDone), findsOneWidget);
  final taskFinder = find.byType(TaskDone);
  expect(taskFinder, findsOneWidget);

  await tester.pumpAndSettle();

  await tester.drag(taskFinder, const Offset(-400, 0));
  await tester.pumpAndSettle();

  verify(() => mockTaskProvider.removeTask(task)).called(1);
  verify(() => mockStatsProvider.removeTask(task)).called(1);

  await tester.pump(const Duration(milliseconds: 200));
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Usunięto wykonane zadanie'), findsOneWidget);
});
}
