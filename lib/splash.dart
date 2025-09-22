import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Administrator_HomeScreen.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Login_page.dart';
import 'package:http/http.dart' as http;

import 'ui_decoration_tools/constant.dart';

class Catid {
  final String F_Name;
  final String F_Number;
  final String F_AadhaarCard;

  Catid(
      {required this.F_Name, required this.F_Number, required this.F_AadhaarCard});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
        F_Name: json['FName'],
        F_Number: json['FNumber'],
        F_AadhaarCard: json['FAadharCard']);
  }
}
//Hello World
class Splash extends StatefulWidget {
  static const route = "/";
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future<List<Catid>> fetchData_account(llogin) async {
    var url = Uri.parse("https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${llogin}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  void init() async {
    await Future.delayed(Duration(milliseconds: 500));

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? loginNumber = pref.getString("number");

    if (loginNumber != null && loginNumber.isNotEmpty) {
      final result = await fetchData_account(loginNumber);

      if (result.isNotEmpty) {
        String role = result.first.F_AadhaarCard;

        if (role == "Administrator") {
          Navigator.of(context).pushReplacementNamed(AdministratorHome_Screen.route);
        } else if (role == "FieldWorkar") {
          Navigator.of(context).pushReplacementNamed(Home_Screen.route);
        } else {
          // Unknown role fallback
          Navigator.of(context).pushReplacementNamed(Login_page.route);
        }
      } else {
        // Data mismatch or user not found
        Navigator.of(context).pushReplacementNamed(Login_page.route);
      }
    } else {
      // No login info saved
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
            Image.asset(AppImages.verify, width: 300, height: 300,),
          ],
        ),
      ),
    );
  }
}
