import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
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
import 'Controller/Show_demand_binding.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FireBaseApi().initNotifications();

//New Update
  // Set initial binding
  TenantBinding();

  runApp(
      MultiProvider(providers: [
  ChangeNotifierProvider(create: (_)=>ThemeProvider()),
  ChangeNotifierProvider(create: (_) => PropertyProvider()),
  ChangeNotifierProvider(create: (_) => PropertyIdProvider()),
  ChangeNotifierProvider(create: (_) => MultiImageUploadProvider()),
  ChangeNotifierProvider(create: (_) => RealEstateShowDataProvider()),

  ],

 child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Poppins',
        ),
      ),


      initialRoute: Splash.route,
      routes: Routes.routes,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // Lock text scaling globally
          child: ThemeSwitcher(
            themeMode: _themeMode,
            toggleTheme: _toggleTheme,
            child: child!,
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
