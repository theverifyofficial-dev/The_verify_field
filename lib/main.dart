import 'dart:convert';
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
    // Tapped notification → navigation
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _handleNotificationNavigation(message);
      });
    });

    // Dynamic links
    _initDynamicLinks();
  }

  String? extractBuildingIdFromBody(String? body) {
    if (body == null) return null;
    final regExp = RegExp(r'Building ID:\s*(\d+)');
    final match = regExp.firstMatch(body);
    if (match != null) return match.group(1);
    return null;
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    try {
      final data = message.data;

      String? type = data['type']?.toString();
      String? flatId = data['flat_id']?.toString();
      String? buildingId = data['building_id']?.toString();

      // Handle nested payload safely
      final nestedPayload = data['payload'];
      if (nestedPayload != null) {
        try {
          Map<String, dynamic> payloadMap = {};
          if (nestedPayload is String) {
            payloadMap = Map<String, dynamic>.from(jsonDecode(nestedPayload));
          } else if (nestedPayload is Map) {
            payloadMap = Map<String, dynamic>.from(nestedPayload);
          }

          buildingId ??= payloadMap['building_id']?.toString() ?? payloadMap['buildingId']?.toString();
          flatId ??= payloadMap['flat_id']?.toString() ?? payloadMap['flatId']?.toString();
        } catch (e) {
          print("❌ Error parsing nested payload: $e");
        }
      }

      // Extract buildingId from body if missing
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") && (buildingId == null || buildingId.isEmpty)) {
        buildingId = extractBuildingIdFromBody(message.notification?.body);
      }

      // Navigate: Building notifications
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") && buildingId != null) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.administaterShowFutureProperty,
              (route) => false,
          arguments: {"fromNotification": true, "buildingId": buildingId},
        );
        return;
      }

      // Navigate: Flat notifications
      if (flatId != null && flatId.isNotEmpty) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.administaterShowRealEstate,
              (route) => false,
          arguments: {"fromNotification": true, "flatId": flatId},
        );
      } else {
        print("⚠️ flatId missing in notification");
      }
    } catch (e) {
      print("❌ Navigation error: $e");
    }
  }

// Unified notification handler
  void _openNotificationPage(RemoteMessage message, {bool fromTerminated = false}) {
    try {
      final data = message.data;
      String? type = data['type']?.toString();
      String? flatId = data['flat_id']?.toString();
      String? buildingId = data['building_id']?.toString();

      // ✅ Nested payload handling
      final nestedPayload = data['payload'];
      if (nestedPayload != null) {
        try {
          Map<String, dynamic> payloadMap = {};
          if (nestedPayload is String) {
            payloadMap = Map<String, dynamic>.from(jsonDecode(nestedPayload));
          } else if (nestedPayload is Map) {
            payloadMap = Map<String, dynamic>.from(nestedPayload);
          }
          buildingId ??= payloadMap['building_id']?.toString() ?? payloadMap['buildingId']?.toString();
          flatId ??= payloadMap['flat_id']?.toString() ?? payloadMap['flatId']?.toString();
        } catch (e) {
          print("❌ Error parsing nested payload: $e");
        }
      }

      // ✅ Extract buildingId from body if still null
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") && (buildingId == null || buildingId.isEmpty)) {
        buildingId = extractBuildingIdFromBody(message.notification?.body);
      }

      // 🔹 Handle building notifications → ADministaterShow_FutureProperty
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") && buildingId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterShowFutureProperty,
                (route) => false,
            arguments: {"fromNotification": true, "buildingId": buildingId},
          );
        });
        return;
      }

      // 🔹 Handle flat notifications → ADministaterShow_realestete
      if (flatId != null && flatId.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (fromTerminated) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AdministratorHome_Screen.route,
                  (route) => false,
            );
          }
          navigatorKey.currentState?.pushNamed(
            Routes.administaterShowRealEstate,
            arguments: {"fromNotification": true, "flatId": flatId},
          );
        });
      } else {
        if (!(type == "BUILDING_UPDATE" || type == "NEW_BUILDING")) {
          print("⚠️ flatId missing in notification");
        }
      }

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
      final type = deepLink.queryParameters['type'];
      final flatId = deepLink.queryParameters['flatId'];
      final buildingId = deepLink.queryParameters['buildingId'];

      if (type == "BUILDING_UPDATE" && buildingId != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.administaterShowFutureProperty,
          arguments: {"fromNotification": true, "buildingId": buildingId},
        );
      } else if (flatId != null) {
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
