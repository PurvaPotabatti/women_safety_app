import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static void initialize(FlutterLocalNotificationsPlugin notificationsPlugin) {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> sendNotification(
      FlutterLocalNotificationsPlugin notificationsPlugin, String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(0, title, body, notificationDetails);
  }
}


