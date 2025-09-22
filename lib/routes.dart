import 'package:flutter/cupertino.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Login_page.dart';
import 'package:verify_feild_worker/splash.dart';
import 'Administrator/Admin_future _property/Administater_Future_Property.dart';
import 'Administrator/Admin_future _property/Future_Property_Details.dart';
import 'Administrator/Administator_Realestate.dart';
import 'Administrator/Administrator_HomeScreen.dart';
class Routes {
  static const String administaterShowRealEstate = '/administater_show_realestate';
  static const String administaterShowFutureProperty = '/administaterShowFutureProperty';
  static const String administaterFuturePropertyDetails = '/administaterFuturePropertyDetails';

  static Map<String, WidgetBuilder> routes = {
    Splash.route: (context) => const Splash(),
    Home_Screen.route: (context) => const Home_Screen(),
    AdministratorHome_Screen.route: (context) => const AdministratorHome_Screen(),
    Login_page.route: (context) => const Login_page(),

    administaterShowRealEstate: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final fromNotification = args?['fromNotification'] ?? false;
      final flatId = args?['flatId'];

      return ADministaterShow_realestete(
        fromNotification: fromNotification,
        flatId: flatId,
      );
    },

    administaterShowFutureProperty: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final fromNotification = args?['fromNotification'] ?? false;
      final buildingId = args?['buildingId'];

      return ADministaterShow_FutureProperty(
        key: ValueKey(buildingId), // <-- Force rebuild if buildingId changes
        fromNotification: fromNotification,
        buildingId: buildingId,
      );
    },
    administaterFuturePropertyDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      final fromNotification = args?['fromNotification'] ?? false;
      final buildingId = args?['buildingId'];
      final flatId = args?['flatId'];

      return Administater_Future_Property_details(
        fromNotification: fromNotification,
        buildingId: buildingId,
        flatId: flatId,
      );
    },
  };
}
