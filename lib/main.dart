import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:verify_feild_worker/Notification_demo/notification_Service.dart';
import 'package:verify_feild_worker/provider/Theme_provider.dart';
import 'package:verify_feild_worker/provider/main_RealEstate_provider.dart';
import 'package:verify_feild_worker/provider/multile_image_upload_provider.dart';
import 'package:verify_feild_worker/provider/property_id_for_multipleimage_provider.dart';
import 'package:verify_feild_worker/provider/real_Estate_Show_Data_provider.dart';
import 'package:verify_feild_worker/Notification_demo/routes.dart';
import 'package:verify_feild_worker/Z-Screen/splash.dart';
import 'Administrator/AdminInsurance/AdminInsuranceListScreen.dart';
import 'Administrator/Admin_future _property/Administater_Future_Tabbar.dart';
import 'Administrator/Administrator_HomeScreen.dart';
import 'Administrator/SubAdmin/SubAdminAccountant_Home.dart';
import 'Controller/Cache_memory.dart';
import 'Home_Screen.dart';
import 'Home_Screen_click/VideoEditingForField.dart';
import 'Home_Screen_click/live_tabbar.dart';
import 'Internet_Connectivity/NetworkListener.dart';
import 'SocialMediaHandler/SocialMediaHomePage.dart';
import 'SocialMediaHandler/VideoSubmitPage.dart';

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



  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FireBaseApi().initNotifications();

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: 'AIzaSyDri7Gn2OPFa70G3fq2UFCeQj4u8xDLs94',
  );

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkCacheAndShowToast();
    });

    FirebaseMessaging.instance.getToken().then((token) {
      print("🔑 FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Payload: ${message.data}");

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openNotificationPage(message);
      });
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _openNotificationPage(message);
        });
      }
    });

    _initDynamicLinks();
  }


  void openFromNotification({
    required String homeRoute,
    required String detailRoute,
    required Map<String, dynamic> arguments,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {

      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        homeRoute,
            (route) => false,
      );

      navigatorKey.currentState?.pushNamed(
        detailRoute,
        arguments: arguments,
      );
    });
  }

  String? extractBuildingIdFromBody(String? body) {
    if (body == null) return null;
    final regExp = RegExp(r'Building ID:\s*(\d+)');
    final match = regExp.firstMatch(body);
    return match?.group(1);
  }

  void _openNotificationPage(RemoteMessage message, {bool fromTerminated = false}) {
    bool navigationDone = false;
    try {
      final data = message.data;
      String? type = data['type']?.toString();
      String? flatId = data['flat_id']?.toString();
      final demandId = data["demand_id"]?.toString();
      final redemandId = data["redemand_id"]?.toString();
      String? buildingId = data['building_id']?.toString();
      String? propertyId = data['P_id']?.toString();
      String? commercialId = data['commercial_id']?.toString();
      String? plotId = data['plot_id']?.toString();
      // 🔥 PAYMENT NOTIFICATION (ONLY p_id)

      final String rawBody = message.notification?.body ?? "";
      final String body = rawBody
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      final String? pId =
          data['p_id']?.toString() ?? data['P_id']?.toString();

      final bool isFinalPaymentCompleted =
          body.contains("final payment") &&
              body.contains("completed");

      print("🔍 isFinalPaymentCompleted: $isFinalPaymentCompleted");

      if (type == "move_to_completed") {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.addRentedFlatTabbarNew,
              (route) => false,
          arguments: {
            "tabIndex": 2,
            "propertyId": pId,
          },
        );
        return;
      }

      /// 🛡 NEW INSURANCE → ADMIN / SUBADMIN
      if (type == "NEW_INSURANCE_ADMIN" || type == "NEW_INSURANCE_SUBADMIN") {

        final insuranceId = data['insurance_id']?.toString();

        if (insuranceId == null) {
          print("⚠️ Missing insurance_id");
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => AdminInsuranceListScreen(),
            ),
          );
        });

        return;
      }

      if (data['type'] == "EDITOR_Response" && data['P_id'] != null) {
        final int propertyIdFromPayload =
            int.tryParse(data['P_id'].toString()) ?? 0;
        final String? senderRole = data['sender_role']?.toString();
        final String? senderName = data['sender_name']?.toString();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => SubmitVideoForField(
                propertyId: propertyIdFromPayload,
                userName:senderName,
                fromNotification: true,
              ),
            ),
          );
        });
        return;
      }
      if (data['type'] == "FIELDWORKER_MESSAGE" && data['P_id'] != null) {
        final int propertyIdFromPayload =
            int.tryParse(data['P_id'].toString()) ?? 0;
        final String? senderRole = data['sender_role']?.toString();
        final String? senderName = data['sender_name']?.toString();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => SubmitVideoPage(
                propertyId: propertyIdFromPayload,
                userName:senderName,
                fromNotification: true,
              ),
            ),
          );
        });
        return;
      }


      if (type == "EDITOR_MESSAGE") {
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
      if (type == "SECOND_PAYMENT_ACCEPTED") {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.administaterShowFutureProperty,
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

      if (type == "SECOND_PAYMENT_ADDED"||type == "FINAL_PAYMENT_ADDED" || type == "FINAL_PAYMENT_ACCEPTED") {
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
      //Commercial

      if (
      (type == "NEW_COMMERCIAL" || type == "COMMERCIAL_UPDATED") &&
          commercialId != null
      ) {
        Future.delayed(const Duration(milliseconds: 350), () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                Routes.AdminFieldCommercial,
                    (route) => false,
                arguments: {
                  "fromNotification": true,
                  "commercialId": commercialId,
                  "tabIndex": 2,
                },
              );
        });
        return;
      }

      // Plot
      if ((type == "NEW_PLOT" || type == "PLOT_UPDATED") && plotId != null) {
        Future.delayed(const Duration(milliseconds: 350), () {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            Routes.AdminFieldPlot,
                (route) => false,  // tabbar route
            arguments: {
              "fromNotification": true,
              "plotId": plotId,
              "tabIndex": 1,   // ✅ plot tab
            },
          );
        });
        return;
      }

      // 🔹 Handle NEW_FLAT notification → Administater_Future_Property_details
      if (
      (type == "NEW_FLAT" || type == "FLAT_UPDATE") &&
          buildingId != null &&
          flatId != null
      )
      {
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
                    builder: (_) => SocialMediaHomePage(
                      highlightPropertyId: data['main_id']?.toString(),   // 👈 FIXED KEY
                    ),
                  ),
                );

                return;
              }

        // 3️⃣ VIDEO SUBMITTED → Social Media Home Page
              if (type == "VIDEO_SUBMITTED") {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => SocialMediaHomePage(
                      highlightPropertyId: data['main_id']?.toString(),   // 👈 FIXED KEY
                    ),
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

      if (type == "DEMAND_ASSIGNED" && demandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminDemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": demandId,
          },
        );
        return;
      }


      if (type == "Demand_Transfer_to_subadmin" && demandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminDemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": demandId,
          },
        );
        return;
      }


      if (type == "REDEMAND_ASSIGNED" && redemandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminRedemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": redemandId,
          },
        );
        return;
      }

      if (type == "ReDemand_Transfer_to_subadmin" && redemandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminRedemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": redemandId,
          },
        );
        return;
      }

      if (type == "DEMAND_ASSIGNED_TO_FIELD_WORKAR" && demandId != null) {
        openFromNotification(
          homeRoute: Home_Screen.route,
          detailRoute: Routes.FieldDemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": demandId,
          },
        );
        return;
      }

      /// 🔒 DEMAND CLOSED → ADMIN
      if (type == "DEMAND_UPDATE_ADMIN" && demandId != null) {
        openFromNotification(
          homeRoute: AdministratorHome_Screen.route,
          detailRoute: Routes.AdminDemandDetails,
          arguments: {
            "fromNotification": true,
            "demandId": demandId,
          },
        );
        return;
      }


      /// 🔒 DEMAND CLOSED → SUBADMIN
      if (type == "DEMAND_UPDATE_SUBADMIN" && demandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminDemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": demandId,
          },
        );
        return;
      }

      if (type == "REDEMAND_ASSIGNED_TO_FIELDWORKER" && redemandId != null) {
        openFromNotification(
          homeRoute: Home_Screen.route,
          detailRoute: Routes.FieldRedemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": redemandId,
          },
        );
        return;
      }

      if (type == "REDEMAND_CLOSED_TO_ADMIN" && redemandId != null) {
        openFromNotification(
          homeRoute: AdministratorHome_Screen.route,
          detailRoute: Routes.AdminRedemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": redemandId, // 👈 yes, key stays demandId
          },
        );
        return;
      }


      if (type == "REDEMAND_CLOSED_TO_SUBADMIN" && redemandId != null) {
        openFromNotification(
          homeRoute: SubAdminHomeScreen.route,
          detailRoute: Routes.subAdminRedemandDetail,
          arguments: {
            "fromNotification": true,
            "demandId": redemandId,
          },
        );
        return;
      }

      if (
      [
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
          Routes.administaterShowFutureProperty,   // ✅ tabbar route
          arguments: {
            "fromNotification": true,
            "buildingId": buildingId,
            "tabIndex": 0,          // ✅ building tab
          },
        );
        return;
      }

      // ✅ Handle NEW_FLAT → Administater_Future_Property_details
      else if (
      (type == "NEW_FLAT" || type == "FLAT_UPDATE") &&
          buildingId != null &&
          flatId != null
      ) {
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
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'PoppinsMedium', // 👈 THIS IS THE KEY
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'PoppinsMedium', // 👈 REQUIRED
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
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
