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
import 'Home_Screen_click/live_tabbar.dart';
import 'Internet_Connectivity/NetworkListener.dart';
import 'SocialMediaHandler/SocialMediaHomePage.dart';



final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background Message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await dotenv.load(fileName: ".env");
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

    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 FCM Token: $token");
    });

    // ✅ Foreground notification (app open, just show or log, not navigate)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");
      // You can show local notification here if needed
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openNotificationPage(message); // 👈 use your old function
      });
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _openNotificationPage(message); // 👈 use your old function
        });
      }
    });

    // ✅ Dynamic Links
    _initDynamicLinks();
  }

  /// Extract buildingId from body
  String? extractBuildingIdFromBody(String? body) {
    if (body == null) return null;
    final regExp = RegExp(r'Building ID:\s*(\d+)');
    final match = regExp.firstMatch(body);
    return match?.group(1);
  }

  void _openNotificationPage(RemoteMessage message, {bool fromTerminated = false}) {
    try {
      final data = message.data;
      String? type = data['type']?.toString();
      String? flatId = data['flat_id']?.toString();
      String? buildingId = data['building_id']?.toString();
      String? propertyId = data['P_id']?.toString();
      // 🔹 First Payment → OPEN TAB 0
      if (type == "RENTED_OUT_UPDATED") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterAddRentedFlatTabbar,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "propertyId": propertyId,
              "tabIndex": 0,
            },
          );
        });
        return;
      }

      // 🔹 Second Payment → OPEN TAB 1
      if (type == "SECOND_PAYMENT_ADDED") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterAddRentedFlatTabbar,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "propertyId": propertyId,
              "tabIndex": 1,
            },
          );
        });
        return;
      }
      if (type == "FINAL_PAYMENT_ADDED") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterAddRentedFlatTabbar,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "propertyId": propertyId,
              "tabIndex": 1,
            },
          );
        });
        return;
      }
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
          buildingId ??= payloadMap['building_id']?.toString() ??
              payloadMap['buildingId']?.toString();
          flatId ??= payloadMap['flat_id']?.toString() ??
              payloadMap['flatId']?.toString();
        } catch (e) {
          print("❌ Error parsing nested payload: $e");
        }
      }

      // ✅ Extract buildingId from body if still null
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") &&
          (buildingId == null || buildingId.isEmpty)) {
        buildingId = extractBuildingIdFromBody(message.notification?.body);
      }

      // 🔹 Handle building notifications → ADministaterShow_FutureProperty
      if ((type == "BUILDING_UPDATE" || type == "NEW_BUILDING") &&
          buildingId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterShowFutureProperty,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "buildingId": buildingId
            },
          );
        });
        return;
      }

      // 🔹 Handle NEW_FLAT notification → Administater_Future_Property_details
      if (type == "NEW_FLAT" || type == "FLAT_UPDATE" && buildingId != null && flatId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (fromTerminated) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              AdministratorHome_Screen.route,
                  (route) => false,
            );
          }
          navigatorKey.currentState?.pushNamed(
            Routes.administaterFuturePropertyDetails,
            arguments: {
              "fromNotification": true,
              "buildingId": buildingId,
              "flatId": flatId,
            },
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
            arguments: {
              "fromNotification": true,
              "flatId": flatId},
          );
        });
      }

      if (type == "CONTACT_FORM") {
        print("📨 Navigating to WebQueryPage with payload: $data");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterWebQuery,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "subid": data['subid'] ?? '',
              "times": data['times'] ?? '',
              "phone": data['phone'] ?? '',
              "name": data['name'] ?? '',
              "dates": data['dates'] ?? '',
              "message": data['message'] ?? '',
            },
          );
        });
        return;
      }

        // 1️⃣ EDITOR REPLY → LiveTabbar (Tab 2 + highlight)
              if (type == "EDITOR_REPLY") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => LiveTabbar(
                      initialIndex: 1,
                      highlightPropertyId: data['main_id']?.toString(),
                    ),
                  ),
                );
                return;
              }

        // 2️⃣ FIELDWORKER REPLY → Social Media Home Page
              if (type == "FIELDWORKER_REPLY") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => const SocialMediaHomePage(),
                  ),
                );
                return;
              }

        // 3️⃣ VIDEO SUBMITTED → Social Media Home Page
              if (type == "VIDEO_SUBMITTED") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => const SocialMediaHomePage(),
                  ),
                );
                return;
              }

        // 4️⃣ EDITOR RECEIVED → LiveTabbar (Tab 2 + highlight)
              if (type == "EDITOR_RECEIVED") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => LiveTabbar(
                      initialIndex: 1,
                      highlightPropertyId: data['main_id']?.toString(),
                    ),
                  ),
                );
                return;
              }

        // 5️⃣ VIDEO UPLOADED → LiveTabbar (Tab 2 + highlight)
              if (type == "VIDEO_UPLOADED") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => LiveTabbar(
                      initialIndex: 1,
                      highlightPropertyId: data['main_id']?.toString(),
                    ),
                  ),
                );
                return;
              }


      // 🔹 Handle Agreements (NEW, UPDATED, ACCEPTED, REJECTED)
      if ([
        "NEW_AGREEMENT",
        "AGREEMENT_UPDATED",
        "AGREEMENT_ACCEPTED",
        "AGREEMENT_REJECTED",
      ].contains(type)) {
        final agreementId = data['id']?.toString() ?? '';
        final propertyId = data['property_id']?.toString() ?? '';

        if (agreementId.isEmpty) {
          print("⚠️ Missing agreementId in notification");
          return;
        }

        print("🔔 Notification Data => ${message.data}");
        print("📨 Type => ${data['type']}");

        String? targetRoute;

        if (type == "NEW_AGREEMENT" || type == "AGREEMENT_UPDATED") {
          targetRoute = Routes.adminAgreementPending;
        } else if (type == "AGREEMENT_REJECTED") {
          targetRoute = Routes.fieldAgreementPending;
        } else if (type == "AGREEMENT_ACCEPTED") {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.fieldAgreementAccepted,
                (route) => false,
            arguments: {
              "fromNotification": true,
              "tabIndex": 1,
            },
          );
          return;
        }

        if (targetRoute != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              targetRoute!,
                  (route) => false,
              arguments: {
                "fromNotification": true,
                "agreementId": agreementId,
                "propertyId": propertyId,
              },
            );
          });
        } else {
          print("⚠️ No matching route for agreement type: $type");
        }

        return; // ✅ stop further navigation
      }

    } catch (e) {
      print("❌ Navigation error: $e");
    }
  }

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
          arguments: {
            "fromNotification": true,
            "buildingId": buildingId,
          },
        );
      }
      // ✅ Handle NEW_FLAT → Administater_Future_Property_details
      else if (type == "NEW_FLAT"|| type == "FLAT_UPDATE" && buildingId != null && flatId != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.administaterFuturePropertyDetails,
          arguments: {
            "fromNotification": true,
            "buildingId": buildingId,
            "flatId": flatId,
          },
        );
      }
      else if (flatId != null) {
        navigatorKey.currentState?.pushNamed(
          Routes.administaterShowRealEstate,
          arguments: {
            "fromNotification": true,
            "flatId": flatId,
          },
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
    final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      textTheme: ThemeData.light()
          .textTheme
          .apply(fontFamily: 'Poppins', bodyColor: Colors.black87),
    );

    final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      textTheme: ThemeData.dark()
          .textTheme
          .apply(fontFamily: 'Poppins', bodyColor: Colors.white),
    );

    return NetworkListener(
      child: AnimatedTheme(
        data: _themeMode == ThemeMode.dark ? darkTheme : lightTheme,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: _themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
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
        ),
      ),
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
