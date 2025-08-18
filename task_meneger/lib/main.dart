import 'package:flutter/material.dart';
import 'package:task_meneger/modules/task_module/data/repo/task_repo.dart';
import 'package:task_meneger/modules/task_module/data/services/notification_service.dart';
import 'package:task_meneger/modules/task_module/data/source/task_db.dart';
import 'package:task_meneger/modules/page_module/ui/home_page.dart';
import 'package:task_meneger/modules/page_module/providers/page_provider.dart';
import 'package:task_meneger/modules/stats_module/providers/stats_provider.dart';
import 'package:task_meneger/modules/task_module/providers/task_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  await TaskDb.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PageProvider>(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(TaskRepo(), NotificationService())
        ),
        ChangeNotifierProvider<StatsProvider>(
          create: (context) => StatsProvider()
        ),
      ],
      builder: (context, _) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menedżer zadań',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple[700]!),
      ),
      home: const MyHomePage(),
    );
  }
}
