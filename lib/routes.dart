import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Login_page.dart';
import 'package:verify_feild_worker/splash.dart';
import 'Add_Rented_Flat_New/Add_Rented_Flat_Tabbar_New.dart';
import 'Administrator/Admin_future _property/Administater_Future_Property.dart';
import 'Administrator/Admin_future _property/Future_Property_Details.dart';
import 'Administrator/Administator_Add_Rented_Flat_Tabbar.dart' hide AdministatorAddRentedFlatTabbar;
import 'Administrator/Administator_Agreement/Admin_Agreement_details.dart';
import 'Administrator/Administator_Realestate.dart';
import 'Administrator/Administrator_HomeScreen.dart';
import 'Rent Agreement/details_agreement.dart';
import 'Rent Agreement/history_tab.dart';
import 'Web_query/web_query.dart';
import 'Administrator/All_Rented_Flat/Administator_Add_Rented_Flat_Tabbar.dart';

class Routes {

  static const String administaterShowRealEstate = '/administater_show_realestate';
  static const String administaterShowFutureProperty = '/administaterShowFutureProperty';
  static const String administaterFuturePropertyDetails = '/administaterFuturePropertyDetails';
  static const String administaterWebQuery = '/administaterWebQuery';
  static const String fieldAgreementAccepted = '/fieldAgreementAccepted';
  static const String fieldAgreementPending = '/fieldAgreementPending';
  static const String adminAgreementPending = '/adminAgreementPending';
  static const String administaterAddRentedFlatTabbar = "/AdministatorAddRentedFlatTabbar";
  static const String addRentedFlatTabbarNew = "/AddRentedFlatTabbarNew";

  static Map<String, WidgetBuilder> routes = {
    Splash.route: (context) => const Splash(),
    Home_Screen.route: (context) => const Home_Screen(),
    AdministratorHome_Screen.route: (context) => const AdministratorHome_Screen(),
    Login_page.route: (context) => const Login_page(),

    // 🔸 Admin Real Estate View
    administaterShowRealEstate: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return ADministaterShow_realestete(
        fromNotification: args['fromNotification'] ?? false,
        flatId: args['flatId'],
      );
    },

    administaterWebQuery: (context) => WebQueryPage(),

    addRentedFlatTabbarNew: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};

      return AddRentedFlatTabbarNew(
        tabIndex: args["tabIndex"] ?? 2,
      );
    },

    // 🔸 Admin Future Property List
    administaterShowFutureProperty: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return ADministaterShow_FutureProperty(
        key: ValueKey(args['buildingId']),
        fromNotification: args['fromNotification'] ?? false,
        buildingId: args['buildingId'],
      );
    },

    // 🔸 Admin Future Property Details
    administaterFuturePropertyDetails: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      return Administater_Future_Property_details(
        fromNotification: args['fromNotification'] ?? false,
        buildingId: args['buildingId'],
        flatId: args['flatId'],
      );
    },

    // 🔸 Field Worker - Accepted Agreements
    fieldAgreementAccepted: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      final tabIndex = args['tabIndex'] ?? 0;
      return HistoryTab(defaultTabIndex: tabIndex);
    },

    // 🔸 Field Worker - Pending Agreements
    fieldAgreementPending: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      final id = args['agreementId']?.toString();
      if (id == null || id.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('⚠️ Missing Agreement ID (Field Pending)', style: TextStyle(fontSize: 16))),
        );
      }
      return AgreementDetailPage(agreementId: id);
    },

    // 🔸 Admin - Pending Agreements
    adminAgreementPending: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
      final id = args['agreementId']?.toString();
      if (id == null || id.isEmpty) {
        return const Scaffold(
          body: Center(child: Text('⚠️ Missing Agreement ID (Admin Pending)', style: TextStyle(fontSize: 16))),
        );
      }
      return AdminAgreementDetails(agreementId: id);
    },

    // 🔥 NEW — Admin Rented Flat Tabbar (Booking/Pending/Complete)
    administaterAddRentedFlatTabbar: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};

      return AdministatorAddRentedFlatTabbar(
        fromNotification: args["fromNotification"] ?? false,
        flatId: args["propertyId"]?.toString(),
        tabIndex: args["tabIndex"] ?? 0,
      );
    },
  };
}
