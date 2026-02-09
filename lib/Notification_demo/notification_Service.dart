import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FireBaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // 🔔 Request permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔧 Local notifications setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // 🔑 Token
    final token = await _firebaseMessaging.getToken();
    print('🔑 FCM Token: $token');

    // 📬 Terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) handleMessage(message);
    });

    // 📬 Background → foreground
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // 📬 Foreground
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotification(message);
      handleMessage(message);
    });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('🔕 Background message: ${message.messageId}');
}


@pragma('vm:entry-point')
Future<void> BackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final notification = message.notification;
  final data = message.data;

  if (notification != null) {
    print(" Background Title: ${notification.title}");
    print(" Background Body: ${notification.body}");
  }

  if (data.isNotEmpty) {
    print(" Background Payload: $data");
    if (data.containsKey('payload')) {
      print(" Background Payload value: ${data['payload']}");
    }
  }
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
