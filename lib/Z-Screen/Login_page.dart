import 'package:firebase_messaging/firebase_messaging.dart';
import '../../AppLogger.dart';
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
import 'FieldApplication.dart';


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
    var url = Uri.parse("https://verifyrealestateandservices.in/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${_mobileController.text}");
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
                    'Hey, Sign in to your existing account or apply to become a Verify Field Agent.',
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

                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
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

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                            ),

                            TextButton(
                              onPressed: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const FieldAgentRegisterScreen(),
                                  ),
                                );

                              },
                              child: const Text(
                                "Apply as Field Agent",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          ],
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
      String? fcmToken;

      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        //print("⚠️ FCM failed, continuing login...");
        fcmToken = "";
      }
      fcmToken ??= "";
      AppLogger.log("🔑 FCM Token: $fcmToken");

      // API call with number, password, and token
      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Field%20Application/Login_Api_Field_application.php",
      ).replace(queryParameters: {
        "FNumber": number,
        "FPassword": password,
        "FCM": fcmToken,
      });

      final response = await http.get(uri);

      AppLogger.log("📩 Raw Response: ${response.body}");

      final Map<String, dynamic> resBody = json.decode(response.body);
      final String apiStatus = (resBody["status"] ?? "").toString().trim();
      final String apiMessage = resBody["message"]?.toString() ?? "";

      if (apiStatus == "success" && resBody["data"] != null) {
        final Map<String, dynamic> user =
        Map<String, dynamic>.from(resBody["data"]);

        // Save data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id', user["id"] is int
            ? user["id"]
            : int.tryParse(user["id"].toString()) ?? 0);
        await prefs.setString('name', user["FName"]?.toString() ?? "");
        await prefs.setString('number', user["FNumber"]?.toString() ?? "");
        await prefs.setString('post', user["FAadharCard"]?.toString() ?? "");
        await prefs.setString('location', user["F_Location"]?.toString() ?? "");
        await prefs.setString('fcmToken', fcmToken ?? "");

        AppLogger.log("Saved Local FCM: ${prefs.getString('fcmToken')}");

        if (!context.mounted) return;

        Fluttertoast.showToast(
          msg: apiMessage.isNotEmpty ? apiMessage : "Login Successful ✅",
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
      } else if (apiStatus == "error") {
        // API itself blocks login for pending/rejected accounts and sends
        // a human-readable message, e.g.:
        // "Your account has been rejected. Please contact the administrator."
        // "Your account is pending approval. Please wait for admin approval."
        Fluttertoast.showToast(
          msg: apiMessage.isNotEmpty ? apiMessage : "Login failed.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );

        if (!context.mounted) return;
        final String lowerMsg = apiMessage.toLowerCase();

        if (lowerMsg.contains("reject")) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RejectedScreen()),
          );
        } else if (lowerMsg.contains("pending")) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const WaitingApprovalScreen()),
          );
        }
        // else: a plain invalid-number/password message under the same
        // "error" status — toast above is enough, stay on the login screen.
      } else {
        Fluttertoast.showToast(
          msg: apiMessage.isNotEmpty ? apiMessage : "Invalid Number or Password ❌",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      AppLogger.log("❌ Error: $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

}