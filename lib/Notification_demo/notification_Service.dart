import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class FireBaseApi {
  final _fireBaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await Firebase.initializeApp();

    await _fireBaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    final fCMToken = await _fireBaseMessaging.getToken();
    print("🔑 FCM Token: $fCMToken");

    FirebaseMessaging.onBackgroundMessage(BackgroundMessageHandler);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onMessage.listen((message) {
      print(" Foreground message: ${message.notification?.title}");
      showLocalNotification(message);
      handleMessage(message);
    });
  }
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

  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(''),
    icon: '@mipmap/ic_launcher',
  );

  const platformDetails = NotificationDetails(android: androidDetails);

  flutterLocalNotificationsPlugin.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformDetails,
  );
}
