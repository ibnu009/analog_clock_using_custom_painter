import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = IOSInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: android, iOS: ios);
    await notifications.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
      },
    );
  }

  static Future showNotificationSchedule({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduleDate, tz.local),
          await notificationDetails(),
          payload: payload,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id 3',
          'StockbitNotificactionChannel',
          channelDescription: 'Stockbit technical test channel description',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: IOSNotificationDetails());
  }

  static void cancel() => notifications.cancelAll();
}
