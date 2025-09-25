import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_meneger/modules/task_module/data/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late MockNotificationsPlugin mockPlugin;
  late NotificationService service;

  setUp(() {
    mockPlugin = MockNotificationsPlugin();
    service = NotificationService(mockPlugin);
  });

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));

    registerFallbackValue(tz.TZDateTime.now(tz.local));
    registerFallbackValue(
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'test_channel',
        'Test Notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    ),
  );
  registerFallbackValue(AndroidScheduleMode.inexactAllowWhileIdle);
  registerFallbackValue(DateTimeComponents.dateAndTime);
  });

  test('update powinien wywołać cancel i schedule', () async {
    when(() => mockPlugin.cancel(any())).thenAnswer((_) async => {});
    when(
      () => mockPlugin.zonedSchedule(
        any(),
        any(),
        any(),
        any(),
        any(),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => {});

    final now = DateTime.now();

    await service.update(1, 'Test', 'Opis', now);

    verify(() => mockPlugin.cancel(1)).called(1);
    verify(
      () => mockPlugin.zonedSchedule(
        1,
        'Przypomnienie zadania: Test',
        'Opis',
        any(),
        any(),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        payload: any(named: 'payload'),
      ),
    ).called(1);
  });
}
