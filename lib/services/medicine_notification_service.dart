import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MedicineNotificationService {
  /// Convert reminder ID (Firebase key) to stable int
  static int notificationIdFromReminderId(String id) {
    return id.hashCode & 0x7fffffff;
  }

  /// Calculate next trigger time
  static DateTime calculateNextTime({
    required String time, // HH:mm
  }) {
    final now = DateTime.now();
    final parts = time.split(':');

    DateTime scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Schedule daily medicine reminder
  static Future<void> scheduleReminder({
    required String reminderId,
    required String medicineName,
    required String time, // HH:mm
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snap = await FirebaseDatabase.instance
        .ref("users/$uid/settings/notificationsEnabled")
        .get();

    if (snap.exists && snap.value == false) {
      return; // notifications turned OFF
    }

    final int id = notificationIdFromReminderId(reminderId);
    final DateTime scheduledTime = calculateNextTime(time: time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Pocket Doctor',
      'It’s time to take your $medicineName',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminders',
          channelDescription: 'Medication reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancel reminder
  static Future<void> cancelReminder(String reminderId) async {
    final int id = notificationIdFromReminderId(reminderId);
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
