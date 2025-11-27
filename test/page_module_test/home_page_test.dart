import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:task_meneger/modules/page_module/providers/page_provider.dart';
import 'package:task_meneger/modules/page_module/ui/home_page.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';

class MockPageProvider extends Mock implements PageProvider {}
class MockTaskProvider extends Mock implements TaskProvider {}
class MockStatsProvider extends Mock implements StatsProvider {}

void main() {
  late MockPageProvider pageProvider;
  late MockTaskProvider taskProvider;
  late MockStatsProvider statsProvider;

  setUp(() {
    pageProvider = MockPageProvider();
    taskProvider = MockTaskProvider();
    statsProvider = MockStatsProvider();
    when(() => pageProvider.currentPage).thenReturn(0);
    when(() => taskProvider.completedTasks,).thenReturn([]);
    when(() => taskProvider.upcomingTasks,).thenReturn([]);
    when(() => taskProvider.upcomingTasksIds,).thenReturn([]);
    when(() => taskProvider.getTasks(),).thenAnswer((_) async =>{});
    when(() => statsProvider.completed,).thenReturn(0);
    when(() => statsProvider.maxTasksInWeekday,).thenReturn(0);
    when(() => statsProvider.pending,).thenReturn(0);
    when(() => statsProvider.productiveWeekdayName,).thenReturn('Monday');
    when(() => statsProvider.statsInit(completedTasks: [], upcomingTasksCount: 0),).thenAnswer((_) async =>{});
  });

  Widget homepage(){
    return MultiProvider(providers: [
      ChangeNotifierProvider<PageProvider>.value(value: pageProvider),
      ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
      ChangeNotifierProvider<StatsProvider>.value(value: statsProvider)
    ],child: MaterialApp(home:MyHomePage()));
  }

  group('HomePage tests', () {
    testWidgets('HomePage has got AppBar, IndexedStack i BottomNavigationBar with elements', (tester) async {
      await tester.pumpWidget(homepage());
      await tester.pumpAndSettle();
      
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text("Menedżer zadań osobistych"), findsOneWidget);
      expect(find.byType(IndexedStack), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      final b = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar).first);

      expect((b.items[0].icon as Icon).icon, Icons.home);
      expect(b.items[0].label, "Ekran główny");

      expect((b.items[1].icon as Icon).icon, Icons.stacked_bar_chart);
      expect(b.items[1].label, "Statystyki");
    });
  });

  testWidgets('Tapping bottom navigation updates PageProvider', (tester) async {
    when(() => pageProvider.setCurrentPage(1)).thenReturn(null);

    await tester.pumpWidget(homepage());

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    await tester.tap(find.byIcon(Icons.stacked_bar_chart));
    await tester.pumpAndSettle();

    verify(() => pageProvider.setCurrentPage(1)).called(1);
  });
}
