import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Reset_password/forget.dart';
import 'Administrator/Administrator_HomeScreen.dart';
import 'Demo.dart';
import 'Home_Screen.dart';
import 'ui_decoration_tools/constant.dart';

class Catid {
  final String F_Name;
  final String F_Number;
  final String FAadharCard;
  final String FLocation;

  Catid(
      {required this.F_Name, required this.F_Number, required this.FAadharCard, required this.FLocation});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
        F_Name: json['FName'],
        F_Number: json['FNumber'],
        FAadharCard: json['FAadharCard'],
        FLocation: json['F_Location']);
  }
}

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

  Future<List<Catid>> fetchData_account() async {
    var url = Uri.parse("https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=${_mobileController.text}");
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

                      final number = _mobileController.text;
                      final password = _passController.text;

                      final response = await http.get(Uri.parse(
                          "https://verifyserve.social/WebService3_ServiceWork.asmx/Feild_LoginApi?number=$number&password=$password"));

                      if (response.body == '[{"logg":1}]') {
                        final result = await fetchData_account();

                        if (result.isNotEmpty) {
                          final user = result.first;

                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setString('name', user.F_Name);
                          prefs.setString('number', user.F_Number);
                          prefs.setString('location', user.FLocation);

                          Fluttertoast.showToast(
                            msg: "Login successful",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                          );

                          if (user.FAadharCard == "Administrator") {
                            Navigator.of(context).pushReplacementNamed(
                                AdministratorHome_Screen.route);
                          } else if (user.FAadharCard == "FieldWorkar") {
                            Navigator.of(context)
                                .pushReplacementNamed(Home_Screen.route);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Unknown role: ${user.FAadharCard}",
                              backgroundColor: Colors.orange,
                              textColor: Colors.white,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "No account data found!",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Login Failed",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
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
            Container(
              margin: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      => Forget(),
                      ));
                    },
                      child:
                      Text('Forget password?',style: TextStyle(color: Color.fromRGBO(143, 148, 251, .6,),fontStyle: FontStyle.italic,fontSize: 16),)
                  ),
              ],
              ),
            )

          ],

              ),
            )
       ]
        )
    ));
  }
}
