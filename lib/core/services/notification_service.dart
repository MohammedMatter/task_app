import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  static Future<void> init() async {

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _notification.initialize(settings);
  }

  static Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime date}) async {
        log('${id}') ; 
    if (date.isBefore(DateTime.now())) {
      date = DateTime.now().add(Duration(seconds: 30));
    }
    await _notification.zonedSchedule(
      id,
      '⏰ Task Reminder',
      'Finish: ${title} – Due now',
      tz.TZDateTime.from(date, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'task Notifications',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelScheduleNotification({
    required int id,
  }) async {
    
 
    await _notification.cancel(id);
  }
}
