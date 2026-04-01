import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FireBaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('🔕 Background message: ${message.messageId}');
}

void handleMessage(RemoteMessage message) {
  final notification = message.notification;
  final data = message.data;

  if (notification != null) {
    print(" Title: ${notification.title}");
    print(" Body: ${notification.body}");
  }

  if (data.isNotEmpty) {
    print(" Payload: $data");
    if (data.containsKey('payload')) {
      print(" Payload value: ${data['payload']}");
    }
  }
}

void showLocalNotification(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'Important notifications',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails platformDetails =
  NotificationDetails(android: androidDetails);

  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformDetails,
  );
}
