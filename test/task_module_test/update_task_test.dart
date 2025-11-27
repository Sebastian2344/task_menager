import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/alert_dialogs/update_task.dart';
import 'package:task_meneger/shared/model/task.dart';

class MockTaskProvider extends Mock implements TaskProvider {}

void main() {
  late MockTaskProvider mockTaskProvider;
  late Task testTask;

  setUp(() {
    mockTaskProvider = MockTaskProvider();

    testTask = Task(
      id: 123,
      title: 'Stare zadanie',
      description: 'Stary opis',
      deadline: DateTime(2025, 10, 20, 14, 0),
      realisationDate: null, isCompleted: false,
    );

    registerFallbackValue(DateTime.now());
  });

  Widget _wrapWithProviders(Widget child) {
    return ChangeNotifierProvider<TaskProvider>.value(
      value: mockTaskProvider,
      child: MaterialApp(
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('UpdateTask shows initial task data correctly', (tester) async {
    await tester.pumpWidget(_wrapWithProviders(UpdateTask(task: testTask)));
    await tester.pumpAndSettle();

    expect(find.text('Edytuj zadanie'), findsOneWidget);
    expect(find.text('Stare zadanie'), findsOneWidget);
    expect(find.text('Stary opis'), findsOneWidget);
    expect(find.textContaining('Termin:'), findsOneWidget);
    expect(find.text('Ustaw termin'), findsOneWidget);
    expect(find.text('Zapisz'), findsOneWidget);
    expect(find.text('Anuluj'), findsOneWidget);
  });

  testWidgets('Validation shows error when title is empty', (tester) async {
    await tester.pumpWidget(_wrapWithProviders(UpdateTask(task: testTask)));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Nazwa zadania'), '');
    await tester.tap(find.text('Zapisz'));
    await tester.pump();

    expect(find.text('Podaj nazwę zadania'), findsOneWidget);
    verifyNever(() => mockTaskProvider.updateTasks(any(), any(), any(), any(), any()));
  });

  testWidgets('Saving valid form calls updateTasks and shows snackbar', (tester) async {
    when(() => mockTaskProvider.updateTasks(any(), any(), any(), any(), any()))
        .thenAnswer((_) async {});

    await tester.pumpWidget(_wrapWithProviders(UpdateTask(task: testTask)));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nazwa zadania'),
      'Zmienione zadanie',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Opis (opcjonalny)'),
      'Nowy opis',
    );

    await tester.tap(find.text('Zapisz'));
    await tester.pump(const Duration(milliseconds: 200));

    verify(() => mockTaskProvider.updateTasks(
          123,
          'Zmienione zadanie',
          'Nowy opis',
          any(that: isA<DateTime>()),
          null,
        )).called(1);

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Zadanie zaktualizowane'), findsOneWidget);
  });

  testWidgets('Cancel button pops dialog', (tester) async {
    await tester.pumpWidget(
      _wrapWithProviders(
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => UpdateTask(task: testTask),
              );
            },
            child: const Text('Open'),
          );
        }),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });
}