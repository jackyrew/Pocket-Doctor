import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class MedicineNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // INIT
  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(settings);
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

    _initialized = true;
  }

  static int _notificationId(String reminderId) {
    return reminderId.hashCode & 0x7fffffff;
  }

  // SCHEDULE (REFACTORED)
  static Future<void> scheduleReminder({
    required String reminderId,
    required String medicineName,
    required String time,
  }) async {
    await init();

    final int id = _notificationId(reminderId);

    // always cancel before scheduling
    await _plugin.cancel(id);

    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      'Pocket Doctor',
      'Time to take $medicineName',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Reminders to take medicine',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // CANCEL ONE
  static Future<void> cancelReminder(String reminderId) async {
    await init();
    await _plugin.cancel(_notificationId(reminderId));
  }

  // CANCEL ALL
  static Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  static Future<void> showTestNow() async {
    await init();

    await _plugin.show(
      12345,
      'Pocket Doctor TEST',
      'If you see this, notifications work',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Test channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
