import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Administrator_HomeScreen.dart';
import 'package:verify_feild_worker/Home_Screen.dart';
import 'package:verify_feild_worker/Z-Screen/Login_page.dart';
import 'package:http/http.dart' as http;
import '../Administrator/SubAdmin/SubAdminAccountant_Home.dart';
import '../SocialMediaHandler/video_home.dart';
import '../ui_decoration_tools/app_images.dart';
import '../../AppLogger.dart';

class User {
  final String F_Name;
  final String F_Number;
  final String F_AadhaarCard;
  final String? FCM;

  User({
    required this.F_Name,
    required this.F_Number,
    required this.F_AadhaarCard,
    this.FCM,
  });

  factory User.FromJson(Map<String, dynamic> json) {
    return User(
      F_Name: json['FName'],
      F_Number: json['FNumber'],
      F_AadhaarCard: json['FAadharCard'],
      FCM: json['FCM'],
    );
  }
}

class Splash extends StatefulWidget {
  static const route = "/";
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isLoading = true;
  bool _hasNoInternet = false;
  StreamSubscription? _connectivitySubscription;

  Future<List<User>> fetchData_account(String login) async {
    var url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/home_screen.php?FNumber=$login");
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        List listResponse = jsonResponse['data'];
        return listResponse.map((data) => User.FromJson(data)).toList();
      } else {
        throw Exception('API returned success: false');
      }
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
          final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
          if (result != ConnectivityResult.none && _hasNoInternet) {
            // Network wapas aa gaya → retry
            init();
          }
        });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void init() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasNoInternet = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? loginNumber = pref.getString("number");

    if (loginNumber == null || loginNumber.isEmpty) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(Login_page.route);
      return;
    }

    try {
      final result = await fetchData_account(loginNumber);

      if (!mounted) return;

      if (result.isNotEmpty) {
        String role = result.first.F_AadhaarCard;
        if (role == "Administrator") {
          Navigator.of(context)
              .pushReplacementNamed(AdministratorHome_Screen.route);
        } else if (role == "Sub Administrator") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SubAdminHomeScreen()));
        } else if (role == "Editor") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoHomepage()));
        } else if (role == "FieldWorkar") {
          Navigator.of(context).pushReplacementNamed(Home_Screen.route);
        } else {
          Navigator.of(context).pushReplacementNamed(Login_page.route);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(Login_page.route);
      }
    } catch (e) {
      // ❌ Network error → show retry UI
      AppLogger.log("Splash Error: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasNoInternet = true;
      });
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
            const SizedBox(height: 30),

            // ⏳ Loading indicator
            if (_isLoading)
            Text(""),

            // ❌ No internet — retry button
            if (_hasNoInternet) ...[
              const Icon(Icons.wifi_off, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              const Text(
                "No Internet Connection",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: init,
                label: const Text(" "),
              ),
            ],
          ],
        ),
      ),
    );
  }
}