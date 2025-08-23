/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Initialize notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


//button

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false, // Start only after button click
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

Future<void> _showNotification(int id, String title, String body, String payload) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@drawable/logo_notification', // <--- Same here!
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    platformChannelSpecifics,
    payload: payload,
  );
}

String AB = '9';
String CD = '10';

void onStart(ServiceInstance service) {
  Timer.periodic(const Duration(seconds: 10), (timer) {
    print("🔥 Printing every 10 seconds: ${DateTime.now()}");
    if (AB != CD) {
      _showNotification(0, 'Add New Queary in Tenant Demand', 'body', 'payload');

    } else if (AB == CD) {
      print('seccess');
    }
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}


class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String currentImage = '@drawable/logo_notification'; // Default image

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/logo_notification');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTap(response.payload!);
        }
      },
    );
  }



  void _handleNotificationTap(String payload) {
    // Change image based on payload
    setState(() {
      if (payload == 'logo1') {
        currentImage = '@drawable/logo_notification';
      } else if (payload == 'logo2') {
        currentImage = 'assets/images/VerifyLogo.png';
      } else if (payload == 'logo3') {
        currentImage = 'assets/images/VerifyLogo.png';
      }
    });
  }


  //button code


  final service = FlutterBackgroundService();
  bool isServiceRunning = false;

  void startBackgroundTask() async {
    await service.startService();
    setState(() {
      isServiceRunning = true;
    });
  }

  void stopBackgroundTask() async {
    //await service.invoke('stopService');
    setState(() {
      isServiceRunning = false;
    });
  }




  void _handvalue() {
    // Change image based on payload
    setState(() {
      if (AB != CD) {
        _showNotification(0, 'Add New Queary in Tenant Demand', 'body', 'payload');

      } else if (AB == CD) {
        print('seccess');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification and Logo Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(currentImage, height: 150),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showNotification(0, 'Notification 1', 'Tap to change to Logo 1', 'logo1');
                startBackgroundTask();
              },
              child: Text('Show Notification 1'),
            ),
ElevatedButton(
              onPressed: () {
                _showNotification(1, 'Notification 2', 'Tap to change to Logo 2', 'logo2');
              },
              child: Text('Show Notification 2'),
            ),
            ElevatedButton(
              onPressed: () {
                _showNotification(2, 'Notification 3', 'Tap to change to Logo 3', 'logo3');
              },
              child: Text('Show Notification 3'),
            ),

          ],
        ),
      ),
    );
  }
}
*/
