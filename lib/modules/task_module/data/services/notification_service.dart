import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

      NotificationService(this._plugin);

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw')); 
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings,iOS: iosSettings);

    await _plugin.initialize(settings);
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      if (!result.isGranted) {
        return false;
      }
    }

    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    return iosGranted ?? true;
  }

  Future<void> schedule(int id, String title,String? description, DateTime dateTime) async {
    await _plugin.zonedSchedule(
      id,
      'Przypomnienie zadania: $title',
      description,
      tz.TZDateTime.from(dateTime, tz.local),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'todo_channel',
          'ToDo Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> update(int id, String title,String? description, DateTime dateTime) async {
    await cancel(id);
    await schedule(id, title, description,dateTime);
  }
}