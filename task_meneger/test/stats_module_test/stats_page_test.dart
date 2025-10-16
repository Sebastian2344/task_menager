import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/page_module/providers/page_provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/stats_module/ui/stats_page.dart';
import 'package:mocktail/mocktail.dart';

class MockStatsProvider extends Mock implements StatsProvider {}

class MockPageProvider extends Mock implements PageProvider {}

void main() {
  late MockStatsProvider mockStatsProvider;
  late MockPageProvider mockPageProvider;

  setUp(() {
    mockStatsProvider = MockStatsProvider();
    mockPageProvider = MockPageProvider();
    when(() => mockPageProvider.currentPage).thenReturn(1);
  });

  tearDown(() {});
  testWidgets('StatsPage has a title and four StatCards with description', (
    WidgetTester tester,
  ) async {
    when(() => mockStatsProvider.pending).thenReturn(5);
    when(() => mockStatsProvider.completed).thenReturn(10);
    when(() => mockStatsProvider.productiveWeekdayName).thenReturn('Wednesday');
    when(() => mockStatsProvider.maxTasksInWeekday).thenReturn(7);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<StatsProvider>.value(value: mockStatsProvider),
          ChangeNotifierProvider<PageProvider>.value(value: mockPageProvider),
        ],
        child: const MaterialApp(home: StatsPage()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Statystyki'), findsOneWidget);
    expect(find.byType(StatCard), findsNWidgets(4));

    expect(find.text('Zadania do wykonania'), findsOneWidget);
    expect(find.byIcon(Icons.task), findsOneWidget);
    expect(find.text(mockStatsProvider.pending.toString()), findsOneWidget);

    expect(find.text('Wykonane zadania'), findsOneWidget);
    expect(find.byIcon(Icons.done), findsOneWidget);
    expect(find.text(mockStatsProvider.completed.toString()), findsOneWidget);

    expect(find.text('Najbardziej produktywny dzień'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text(mockStatsProvider.productiveWeekdayName.toString()), findsOneWidget);

    expect(find.text('Liczba zadań w tym dniu'), findsOneWidget);
    expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    expect(find.text(mockStatsProvider.maxTasksInWeekday.toString()), findsOneWidget);
  });
}
