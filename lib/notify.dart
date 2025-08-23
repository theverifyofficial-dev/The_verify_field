/*
import 'dart:async';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/routes.dart';
import 'package:verify_feild_worker/splash.dart';

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "Monitoring Started",
      content: "Service is running in background",
    );
  }

  final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
  await notifications.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'mismatch_channel',
    'Mismatch Checker',
    description: 'Checks if string values differ',
    importance: Importance.max,
  );

  final androidPlugin = notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(channel);
  }

  String string1 = '';
  String string2 = '';

  Timer.periodic(const Duration(seconds: 7), (_) async {
    try {
      final res = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/assign_tanant_demand_2nd_table_count_api_location?location_=Sultanpur'));
      if (res.statusCode == 200) {
        string1 = res.body;
      }
    } catch (e) {
      print('Error fetching string1: $e');
    }
  });

  Timer.periodic(const Duration(seconds: 11), (_) async {
    try {
      final res = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/assign_tanant_demand_2nd_table_count_api_location?location_=Sultanpur'));
      if (res.statusCode == 200) {
        string2 = res.body;
      }
    } catch (e) {
      print('Error fetching string2: $e');
    }
  });

  Timer.periodic(const Duration(seconds: 9), (_) async {
    try {
      if (string1.isNotEmpty && string2.isNotEmpty && string1 != string2) {
        await notifications.show(
          0,
          'New Demand',
          'New Demand is Available',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'mismatch_channel',
              'Mismatch Checker',
              channelDescription: 'Checks for string differences',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    } catch (e) {
      print('Notification error: $e');
    }
  });

  Timer.periodic(const Duration(seconds: 13), (_) async {
    try {
      if (string1.isNotEmpty && string2.isNotEmpty && string1 != string2) {
        await notifications.show(
          0,
          'New Demand',
          'New Demand is Available',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'mismatch_channel',
              'Mismatch Checker',
              channelDescription: 'Checks for string differences',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    } catch (e) {
      print('Notification error: $e');
    }
  });
}




*/
