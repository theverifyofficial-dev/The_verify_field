// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class MynotifyApp extends StatefulWidget {
//   @override
//   State<MynotifyApp> createState() => _MynotifyAppState();
// }
//
// class _MynotifyAppState extends State<MynotifyApp> {
//   String stringValue1 = '';
//   String stringValue2 = '';
//
//   late Timer timer5;
//   late Timer timer7;
//   late Timer timer9;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     initNotifications();
//
//     timer5 = Timer.periodic(Duration(seconds: 5), (_) => fetchString1());
//     timer7 = Timer.periodic(Duration(seconds: 7), (_) => checkStrings());
//     timer9 = Timer.periodic(Duration(seconds: 9), (_) => fetchString2());
//   }
//
//   @override
//   void dispose() {
//     timer5.cancel();
//     timer7.cancel();
//     timer9.cancel();
//     super.dispose();
//   }
//
//   Future<void> initNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> showNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'string_diff_channel',
//       'String Difference',
//       channelDescription: 'Notifies when two strings are not equal',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'String Mismatch',
//       'The two string values are not equal!',
//       platformChannelSpecifics,
//     );
//   }
//
//   Future<void> fetchString1() async {
//     final response = await http.get(Uri.parse('https://verifyserve.social/WebService3_ServiceWork.asmx/Feild_LoginApi?number=11&password=11'));
//     if (response.statusCode == 200) {
//       setState(() {
//         stringValue1 = 'Hello';
//         //stringValue1 = response.body;
//       });
//     }
//   }
//
//   Future<void> fetchString2() async {
//     final response = await http.get(Uri.parse('https://verifyserve.social/WebService3_ServiceWork.asmx/Feild_LoginApi?number=11&password=11'));
//     if (response.statusCode == 200) {
//       setState(() {
//         stringValue2 = 'Hellohh';
//         //stringValue2 = response.body;
//       });
//     }
//   }
//
//   void checkStrings() {
//     if (stringValue1.isNotEmpty && stringValue2.isNotEmpty && stringValue1 != stringValue2) {
//       showNotification();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('String Monitor')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('String 1: $stringValue1'),
//               Text('String 2: $stringValue2'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
