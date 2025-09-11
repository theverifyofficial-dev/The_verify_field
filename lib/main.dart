import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verify_feild_worker/Notification_demo/notification_Service.dart';
import 'package:verify_feild_worker/provider/Theme_provider.dart';
import 'package:verify_feild_worker/provider/main_RealEstate_provider.dart';
import 'package:verify_feild_worker/provider/multile_image_upload_provider.dart';
import 'package:verify_feild_worker/provider/property_id_for_multipleimage_provider.dart';
import 'package:verify_feild_worker/provider/real_Estate_Show_Data_provider.dart';
import 'package:verify_feild_worker/routes.dart';
import 'package:verify_feild_worker/splash.dart';
import 'Administrator/Administrator_HomeScreen.dart';
import 'Controller/Show_demand_binding.dart';
import 'Home_Screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// 🔹 Background handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background Message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FireBaseApi().initNotifications();

  // register FCM background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // initial binding
  TenantBinding();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PropertyProvider()),
        ChangeNotifierProvider(create: (_) => PropertyIdProvider()),
        ChangeNotifierProvider(create: (_) => MultiImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => RealEstateShowDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();

    // Print FCM Token
    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 FCM Token: $token");
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _openNotificationPage(message, fromTerminated: true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openNotificationPage(message);
    });
    // Tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);

    // App opened via notification when terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) _handleNotificationNavigation(message);
    });

    // Dynamic links
    _initDynamicLinks();
  }
  void _openNotificationPage(RemoteMessage message, {bool fromTerminated = false}) {
    final flatId = message.data['flat_id'];

    if (fromTerminated) {
      // App was terminated -> set initial stack: AdministratorHome_Screen + NotificationScreen
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AdministratorHome_Screen.route, // 👈 your admin home page
            (route) => false,
      );

      navigatorKey.currentState?.pushNamed(
        Routes.administaterShowRealEstate,
        arguments: {"fromNotification": true, "flatId": flatId},
      );
    } else {
      // App already running -> just push notification screen
      navigatorKey.currentState?.pushNamed(
        Routes.administaterShowRealEstate,
        arguments: {"fromNotification": true, "flatId": flatId},
      );
    }
  }


  // 🔹 Handle notification tap navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    try {
      final flatId = message.data['flat_id'];
      print("➡️ Navigate with flatId: $flatId");

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.administaterShowRealEstate,
            (route) => false,
        arguments: {"fromNotification": true, "flatId": flatId},
      );
    } catch (e) {
      print("❌ Navigation error: $e");
    }
  }

  // 🔹 Setup dynamic links
  void _initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink =
    await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(initialLink?.link);

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(dynamicLinkData.link);
    }).onError((error) {
      print('❌ Dynamic Link error: $error');
    });
  }

  void _handleDeepLink(Uri? deepLink) {
    if (deepLink != null) {
      final flatId = deepLink.queryParameters['flatId'];
      if (flatId != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.administaterShowRealEstate,
          arguments: {"fromNotification": true, "flatId": flatId},
        );
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
      ),
      initialRoute: Splash.route,
      routes: Routes.routes,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ThemeSwitcher(
            themeMode: _themeMode,
            toggleTheme: _toggleTheme,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}

class ThemeSwitcher extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const ThemeSwitcher({
    required this.themeMode,
    required this.toggleTheme,
    required Widget child,
    super.key,
  }) : super(child: child);

  static ThemeSwitcher? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>();
  }

  @override
  bool updateShouldNotify(covariant ThemeSwitcher oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
