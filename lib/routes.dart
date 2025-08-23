import 'package:flutter/cupertino.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Login_page.dart';
import 'package:verify_feild_worker/splash.dart';

import 'Administrator/Administrator_HomeScreen.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    Splash.route: (context) => const Splash(),
    Home_Screen.route: (context) => const Home_Screen(),
    AdministratorHome_Screen.route: (context) => const AdministratorHome_Screen(),
    Login_page.route: (context) => const Login_page(),
    // Register.route: (context) => const Register(),
  };
}