import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_meneger/modules/task_module/data/repo/task_repo.dart';
import 'package:task_meneger/modules/task_module/data/source/task_db.dart';
import 'package:task_meneger/shared/model/task.dart';

class MockTaskDb extends Mock implements TaskDb {}

void main() {
  late MockTaskDb mockDb;
  late TaskRepo repo;

  setUp(() {
    mockDb = MockTaskDb();
    repo = TaskRepo(mockDb);
  });

  test('getTasks zwraca listę Tasków', () async {
    final fakeData = [
      {'id': 1, 'title': 'Task1', 'description': '', 'deadline': DateTime.now().toIso8601String(), 'isCompleted': false, 'realisationDate': null},
      {'id': 2, 'title': 'Task2', 'description': '', 'deadline': DateTime.now().toIso8601String(), 'isCompleted': true, 'realisationDate': null},
    ];

    when(() => mockDb.getTasks()).thenAnswer((_) async => fakeData);

    final tasks = await repo.getTasks();

    expect(tasks.length, 2);
    expect(tasks.first.title, 'Task1');
    verify(() => mockDb.getTasks()).called(1);
  });

  test('insertTask zwraca id wstawionego taska', () async {
    final task = Task(title: 'Nowy', description: '', deadline: DateTime.now(), isCompleted: false, realisationDate: null);

    when(() => mockDb.insertTask(task.toJson())).thenAnswer((_) async => 42);

    final id = await repo.insertTask(task);

    expect(id, 42);
    verify(() => mockDb.insertTask(task.toJson())).called(1);
  }); 

   test('updateTask wywołuje TaskDb.updateTask', () async {
    final task = Task(id: 1, title: 'T', description: '', deadline: DateTime.now(), isCompleted: false, realisationDate: null);

    when(() => mockDb.updateTask(task.toJson())).thenAnswer((_) async => {});

    await repo.updateTask(task);

    verify(() => mockDb.updateTask(task.toJson())).called(1);
  });

  test('deleteTask wywołuje TaskDb.deleteTask', () async {
    when(() => mockDb.deleteTask(1)).thenAnswer((_) async => {});

    await repo.deleteTask(1);

    verify(() => mockDb.deleteTask(1)).called(1);
  });
}