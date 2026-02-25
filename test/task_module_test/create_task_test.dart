import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:task_meneger/modules/task_module/ui/alert_dialogs/create_task.dart';

class MockTaskProvider extends Mock implements TaskProvider {}

class MockStatsProvider extends Mock implements StatsProvider {}

void main() {
  late MockTaskProvider mockTaskProvider;
  late MockStatsProvider mockStatsProvider;

  setUp(() {
    mockTaskProvider = MockTaskProvider();
    mockStatsProvider = MockStatsProvider();

    // Rejestracja fallbacków dla mocktaila (potrzebne przy DateTime)
    registerFallbackValue(DateTime.now());
  });

  Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
        ChangeNotifierProvider<StatsProvider>.value(value: mockStatsProvider),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('createTaskTests', () {
    testWidgets('CreateTask shows all required fields and buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrapWithProviders(const CreateTask()));
      await tester.pumpAndSettle();

      expect(find.text('Dodaj nowe zadanie'), findsOneWidget);

      expect(
        find.widgetWithText(TextFormField, 'Nazwa zadania'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Opis (opcjonalny)'),
        findsOneWidget,
      );

      expect(find.text('Ustaw termin'), findsOneWidget);

      expect(find.text('Zapisz'), findsOneWidget);
      expect(find.text('Anuluj'), findsOneWidget);
    });

    testWidgets('Form validation shows error when title is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(wrapWithProviders(const CreateTask()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz'));
      await tester.pump();

      expect(find.text('Podaj nazwę zadania'), findsOneWidget);
      verifyNever(() => mockTaskProvider.addTask(any(), any(), any()));
    });

    testWidgets('Saving valid form shows snackbar and calls providers', (
      tester,
    ) async {
      when(
        () => mockTaskProvider.addTask(any(), any(), any()),
      ).thenAnswer((_) async {});
      when(() => mockStatsProvider.addTask()).thenReturn(null);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
            ChangeNotifierProvider<StatsProvider>.value(
              value: mockStatsProvider,
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: CreateTask())),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nazwa zadania'),
        'Test task',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Opis (opcjonalny)'),
        'Opis testowy',
      );

      await tester.tap(find.text('Zapisz'));
      await tester.pump(const Duration(milliseconds: 200));

      verify(() => mockTaskProvider.addTask(any(), any(), any())).called(1);
      verify(() => mockStatsProvider.addTask()).called(1);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Zadanie utworzone'), findsOneWidget);
    });

    testWidgets('Cancel button pops the dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithProviders(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CreateTask(),
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Anuluj'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
