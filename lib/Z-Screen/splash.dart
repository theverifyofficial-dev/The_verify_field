import 'dart:async';
import 'dart:convert';
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
import 'FieldApplication.dart';

class User {
  final String F_Name;
  final String F_Number;
  final String F_AadhaarCard;
  final String? FCM;
  final String status;

  User({
    required this.F_Name,
    required this.F_Number,
    required this.F_AadhaarCard,
    required this.status,
    this.FCM,
  });

  factory User.FromJson(Map<String, dynamic> json) {
    return User(
      F_Name: json['FName'],
      F_Number: json['FNumber'],
      F_AadhaarCard: json['FAadharCard'],
      status: json['status'], // <-- NEW
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
  }

  void init() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
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
        User user = result.first;
        _routeByRole(user.F_AadhaarCard, applicationStatus: user.status);
      } else {
        // A 200 response with no data for this number -- fall back to
        // the role saved locally at the last successful login rather
        // than stranding the user here.
        _routeByStoredRole(pref);
      }
    } catch (e) {
      // No internet / request failed. Previously this showed a blocking
      // "No Internet Connection" retry screen and stopped here (see git
      // history). Removed per explicit request (2026-09-22): "remove
      // the code of network error from the splash screen & let user in
      // the app even without internet." Route by the role saved locally
      // at the user's last successful login instead, so they can keep
      // using the app offline. This can't re-check a fresh
      // "Pending"/"Rejected" status without the network, but
      // `Login_page.dart` only ever saves a login locally after the
      // account was already approved (a Pending/Rejected login response
      // is never saved to prefs there), so a cached role here is safe to
      // trust while offline.
      AppLogger.log("Splash Error (offline, routing by cached role): $e");
      if (!mounted) return;
      _routeByStoredRole(pref);
    }
  }

  /// Shared by the online path (fresh role + status from the server, via
  /// `init()`'s success branch) and the offline/fallback path
  /// (`_routeByStoredRole`, cached role only, status unknown) -- same
  /// routing either way; `applicationStatus` is simply omitted offline.
  void _routeByRole(String role, {String? applicationStatus}) {
    if (!mounted) return;

    if (role == "FieldWorkar") {
      if (applicationStatus == "Pending") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WaitingApprovalScreen()),
        );
      } else if (applicationStatus == "Rejected") {
        Navigator.of(context).pushReplacementNamed(Login_page.route);
      } else {
        // "Approved", or unknown because we're routing offline -- a
        // saved FieldWorkar login only ever exists after approval (see
        // `Login_page.dart`), so this is safe to assume without a fresh
        // status check.
        Navigator.of(context).pushReplacementNamed(Home_Screen.route);
      }
    } else if (role == "Administrator") {
      Navigator.of(context).pushReplacementNamed(AdministratorHome_Screen.route);
    } else if (role == "Sub Administrator") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SubAdminHomeScreen()),
      );
    } else if (role == "Editor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VideoHomepage()),
      );
    } else {
      Navigator.of(context).pushReplacementNamed(Login_page.route);
    }
  }

  /// Offline (or empty-data) fallback: route using whatever role was
  /// saved locally at the user's last successful login, instead of
  /// blocking them on the splash screen with no way in.
  void _routeByStoredRole(SharedPreferences pref) {
    _routeByRole(pref.getString('post') ?? '');
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
          ],
        ),
      ),
    );
  }
}