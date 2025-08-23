/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';



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

void onStart(ServiceInstance service) {
  Timer.periodic(const Duration(seconds: 10), (timer) {
    //print("🔥 Printing every 10 seconds: ${DateTime.now()}");
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Service Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isServiceRunning ? stopBackgroundTask : startBackgroundTask,
              child: Text(isServiceRunning ? 'Stop Printing' : 'Start Printing every 10 sec'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
