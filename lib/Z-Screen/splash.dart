// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:verify_feild_worker/Administrator/Administrator_HomeScreen.dart';
// import 'package:verify_feild_worker/Home_Screen.dart';
// import 'package:verify_feild_worker/Z-Screen/Login_page.dart';
// import 'package:http/http.dart' as http;
// import '../Administrator/SubAdmin/SubAdminAccountant_Home.dart';
// import '../SocialMediaHandler/SocialMediaHomePage.dart';
// import '../SocialMediaHandler/video_home.dart';
// import '../ui_decoration_tools/app_images.dart';
//
// class User {
//   final String F_Name;
//   final String F_Number;
//   final String F_AadhaarCard;
//   final String? FCM;
//
//   User({
//     required this.F_Name,
//     required this.F_Number,
//     required this.F_AadhaarCard,
//     required this.FCM,
//   });
//
//   factory User.FromJson(Map<String, dynamic> json) {
//     return User(
//       F_Name: json['FName'],
//       F_Number: json['FNumber'],
//       F_AadhaarCard: json['FAadharCard'],
//       FCM: json['FCM'], // MUST return from backend
//     );
//   }
// }
//
// class Splash extends StatefulWidget {
//   static const route = "/";
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   Future<List<User>> fetchData_account(login) async {
//     var url = Uri.parse(
//         "https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${login}");
//     final responce = await http.get(url);
//     if (responce.statusCode == 200) {
//       List listresponce = json.decode(responce.body);
//       return listresponce.map((data) => User.FromJson(data)).toList();
//     } else {
//       throw Exception('Unexpected error occured!');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   void init() async {
//     await Future.delayed(const Duration(milliseconds: 10));
//
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String? loginNumber = pref.getString("number");
//     String? localFcm = pref.getString("fcmToken");
//
//     if (loginNumber != null && loginNumber.isNotEmpty) {
//       try {
//         final result = await fetchData_account(loginNumber);
//
//         if (result.isNotEmpty) {
//           final user = result.first;
//           final serverFcm = user.FCM;
//
//           print("Server FCM: $serverFcm");
//           print("Local FCM: $localFcm");
//
//           // 🔥 FORCE LOGOUT CHECK
//           if (serverFcm != null &&
//               serverFcm.isNotEmpty &&
//               localFcm != null &&
//               serverFcm != localFcm){
//
//             await pref.clear();
//             Navigator.of(context)
//                 .pushReplacementNamed(Login_page.route);
//             return;
//           }
//
//           // ✅ If FCM matches → allow access
//           String role = user.F_AadhaarCard;
//
//           if (role == "Administrator") {
//             Navigator.of(context)
//                 .pushReplacementNamed(AdministratorHome_Screen.route);
//           }
//           else if (role == "Sub Administrator") {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => SubAdminHomeScreen()),
//             );
//           }
//           else if (role == "Editor") {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => VideoHomepage()),
//             );
//           }
//           else if (role == "FieldWorkar") {
//             Navigator.of(context)
//                 .pushReplacementNamed(Home_Screen.route);
//           }
//           else {
//             await pref.clear();
//             Navigator.of(context)
//                 .pushReplacementNamed(Login_page.route);
//           }
//
//         } else {
//           await pref.clear();
//           Navigator.of(context)
//               .pushReplacementNamed(Login_page.route);
//         }
//
//       } catch (e) {
//         await pref.clear();
//         Navigator.of(context)
//             .pushReplacementNamed(Login_page.route);
//       }
//
//     } else {
//       Navigator.of(context)
//           .pushReplacementNamed(Login_page.route);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               AppImages.verify,
//               width: 300,
//               height: 300,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Administrator_HomeScreen.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Z-Screen/Login_page.dart';
import 'package:http/http.dart' as http;
import '../Administrator/SubAdmin/SubAdminAccountant_Home.dart';
import '../SocialMediaHandler/SocialMediaHomePage.dart';
import '../SocialMediaHandler/video_home.dart';
import '../ui_decoration_tools/app_images.dart';

class User {
  final String F_Name;
  final String F_Number;
  final String F_AadhaarCard;

  User(
      {required this.F_Name,
        required this.F_Number,
        required this.F_AadhaarCard});

  factory User.FromJson(Map<String, dynamic> json) {
    return User(
        F_Name: json['FName'],
        F_Number: json['FNumber'],
        F_AadhaarCard: json['FAadharCard']);
  }
}

class Splash extends StatefulWidget {
  static const route = "/";
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<List<User>> fetchData_account(llogin) async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${llogin}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => User.FromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(Duration(microseconds: 10));

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? loginNumber = pref.getString("number");

    if (loginNumber != null && loginNumber.isNotEmpty) {
      final result = await fetchData_account(loginNumber);

      if (result.isNotEmpty) {
        String role = result.first.F_AadhaarCard;
        if (role == "Administrator") {
          Navigator.of(context).pushReplacementNamed(AdministratorHome_Screen.route);
        } else if (role == "Sub Administrator") {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => SubAdminHomeScreen(),
          ));
        } else if (role == "Editor") {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => VideoHomepage(),
          ));
        } else if (role == "FieldWorkar") {
          Navigator.of(context).pushReplacementNamed(Home_Screen.route);
        } else {
          Navigator.of(context).pushReplacementNamed(Login_page.route);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(Login_page.route);
      }
    }
    else {
      Navigator.of(context).pushReplacementNamed(Login_page.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.verify,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

