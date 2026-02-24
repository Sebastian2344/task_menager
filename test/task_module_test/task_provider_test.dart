import 'package:task_meneger/modules/task_module/data/repo/task_repo.dart';
import 'package:task_meneger/modules/task_module/data/services/notification_service.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/shared/model/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
class MockTaskRepo extends Mock implements TaskRepo {}
class MockNotificationService extends Mock implements NotificationService {}
class FakeTask extends Fake implements Task {}
void main() {
  late MockTaskRepo mockRepo;
  late MockNotificationService mockNotification;
  late TaskProvider provider;


  setUpAll(() {
    registerFallbackValue(FakeTask());
  });

  setUp(() {
    mockRepo = MockTaskRepo();
    mockNotification = MockNotificationService();
    provider = TaskProvider(mockRepo, mockNotification);
  });

  test('getTasks ustawia listę z repo', () async {
    final tasksFromRepo = [
      Task(id: 1, title: 'Task1', description: '', deadline: DateTime.now(), isCompleted: false),
      Task(id: 2, title: 'Task2', description: '', deadline: DateTime.now(), isCompleted: true),
    ];

    when(() => mockRepo.getTasks()).thenAnswer((_) async => tasksFromRepo);

    await provider.getTasks();

    expect(provider.upcomingTasks.length, 1);
    expect(provider.completedTasks.length, 1);
    verify(() => mockRepo.getTasks()).called(1);
  });

  test('addTask dodaje nowy task i scheduluje powiadomienie', () async {
    when(() => mockRepo.insertTask(any())).thenAnswer((_) async => 42);
    when(() => mockNotification.schedule(any(), any(), any(), any())).thenAnswer((_) async => {});

    await provider.addTask('Nowy Task', 'Opis', DateTime.now().add(Duration(days: 1)));

    expect(provider.upcomingTasks.length, 1);
    verify(() => mockRepo.insertTask(any())).called(1);
    verify(() => mockNotification.schedule(any(), any(), any(), any())).called(1);
  });

  test('realisationTask kończy task i cancels notification', () async {
    final task = Task(id: 1, title: 'T', description: '', deadline: DateTime.now(), isCompleted: false);
    provider.addTasklist(task); // dodajemy do listy prywatnej do testu
    when(() => mockRepo.updateTask(any())).thenAnswer((_) async => {});
    when(() => mockNotification.cancel(any())).thenAnswer((_) async => {});
    when(() => mockNotification.schedule(any(), any(), any(), any())).thenAnswer((_) async => {});

    await provider.realisionTask(task, true);

    expect(provider.completedTasks.length, 1);
    expect(provider.upcomingTasks.isEmpty, true);
    expect(provider.completedTasks.first.isCompleted, true);
    expect(provider.completedTasks.first.realisationDate, isNotNull);
    verify(() => mockNotification.cancel(any())).called(1);
    verify(() => mockRepo.updateTask(any())).called(1);
  });

  test('realisationTask oznacza task jako niezakończony i scheduluje powiadomienie', () async {
    final task = Task(id: 1, title: 'T', description: '', deadline: DateTime.now(), isCompleted: true);
    provider.addTasklist(task); // dodajemy do listy prywatnej do testu
    when(() => mockRepo.updateTask(any())).thenAnswer((_) async => {});
    when(() => mockNotification.cancel(any())).thenAnswer((_) async => {});
    when(() => mockNotification.schedule(any(), any(), any(), any())).thenAnswer((_) async => {});

    await provider.realisionTask(task, false);

    expect(provider.completedTasks.length, 0);
    expect(provider.upcomingTasks.length, 1);
    expect(provider.upcomingTasks.first.isCompleted, false);
    expect(provider.upcomingTasks.first.realisationDate, isNull);
    verify(() => mockNotification.schedule(any(), any(), any(), any())).called(1);
    verify(() => mockRepo.updateTask(any())).called(1);
  });

  test('removeTask usuwa task i cancels notification', () async {
    final task = Task(id: 1, title: 'T', description: '', deadline: DateTime.now(), isCompleted: false);
    provider.addTasklist(task); // dodajemy do listy prywatnej do testu

    when(() => mockRepo.deleteTask(task.id!)).thenAnswer((_) async => {});
    when(() => mockNotification.cancel(task.id!)).thenAnswer((_) async => {});

    await provider.removeTask(task);

    expect(provider.upcomingTasks.isEmpty, true);
    verify(() => mockRepo.deleteTask(task.id!)).called(1);
    verify(() => mockNotification.cancel(task.id!)).called(1);
  });

  test('sortTasksByDeadline sortuje listę', () {
    final task1 = Task(id: 1, title: 'T1', description: '', deadline: DateTime.now().add(Duration(days: 2)), isCompleted: false);
    final task2 = Task(id: 2, title: 'T2', description: '', deadline: DateTime.now().add(Duration(days: 1)), isCompleted: false);
    provider.setTasks([task1, task2]);

    provider.sortTasksByDeadline();

    expect(provider.upcomingTasks.first.id, 2);
  });
}