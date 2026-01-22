import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Administrator/Administrator_HomeScreen.dart';
import '../Administrator/SubAdmin/SubAdminAccountant_Home.dart';
import '../Home_Screen.dart';
import '../SocialMediaHandler/video_home.dart';
import '../Custom_Widget/constant.dart';
import '../model/user_model.dart';


class Login_page extends StatefulWidget {
  static const route = "/Login_page";
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  bool _isLoading = false;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<List<UserModel>> fetchData_account() async {
    var url = Uri.parse("https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${_mobileController.text}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => UserModel.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppImages.verify,
                height: 170,
                width: 250,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign In!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hey, Login or Signup to enter the Verify App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Phone Number TextField
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        hintText: "Phone Number",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Iconsax.call, color: Colors.white70),
                      ),
                    ),
                  ),

                  // Password TextField

                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _passController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon:
                          Icon(Iconsax.password_check, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),

                  // Login Button
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      final number = _mobileController.text.trim();
                      final password = _passController.text.trim();

                      await loginUser(context, number, password);

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            : const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
       ]
        )
    ));
  }



  Future<void> loginUser(BuildContext context, String number, String password) async {
    try {
      // Get FCM Token
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
      print("🔑 FCM Token: $fcmToken");

      // API call with number, password, and token
      final response = await http.get(Uri.parse(
        "https://verifyserve.social/WebService4.asmx/new_login_api_for_field_and_admin?FNumber=$number&Password=$password&FCM=$fcmToken",
      ));

      print("📩 Raw Response: ${response.body}");

      final data = json.decode(response.body);

      if (data is List && data.isNotEmpty && data[0]["status"] == "success") {
        final user = data[0];

        // Save data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id', user["id"]);
        prefs.setString('name', user["FName"]);
        prefs.setString('number', user["FNumber"]);
        prefs.setString('post', user["FAadharCard"]);
        prefs.setString('location', user["F_Location"] ?? "");
        prefs.setString('fcmToken', user["FCM"]);

        Fluttertoast.showToast(
          msg: user["message"] ?? "Login Successful ✅",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Navigate by role
        if (user["FAadharCard"] == "Administrator") {
          Navigator.of(context).pushReplacementNamed(AdministratorHome_Screen.route);
        }
        else if (user["FAadharCard"] == "Sub Administrator") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return SubAdminHomeScreen();
          }));

        }
        else if (user["FAadharCard"] == "FieldWorkar") {
          Navigator.of(context).pushReplacementNamed(Home_Screen.route);
        }
        else if (user["FAadharCard"] == "Editor") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
            return VideoHomepage();
          }));
        }
        else {
          Fluttertoast.showToast(
            msg: "Unknown Role: ${user["FAadharCard"]}",
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Invalid Number or Password ❌",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

}
