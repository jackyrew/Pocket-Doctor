import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MedicineNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  static int _idFromReminder(String id) => id.hashCode & 0x7fffffff;

  static Future<void> schedule({
    required String reminderId,
    required String medicineName,
    required String time,
  }) async {
    await init(); // 🔴 GUARANTEE init BEFORE anything

    final id = _idFromReminder(reminderId);
    final now = DateTime.now();
    final parts = time.split(':');

    var date = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }

    await _plugin.cancel(id);

    await _plugin.zonedSchedule(
      id,
      'Pocket Doctor',
      'Time to take $medicineName',
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancel(String reminderId) async {
    await init();
    await _plugin.cancel(_idFromReminder(reminderId));
  }
}
