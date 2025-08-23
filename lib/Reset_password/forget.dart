
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../ui_decoration_tools/constant.dart';
import 'otp.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController number = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<void> checkNumberAndSendOtp(String number) async {
      final apiKey = "ceabde09-483f-11f0-a562-0200cd936042";
      var url = Uri.parse('https://verifyserve.social/WebService4.asmx/CheckMobileNumber?FNumber=$number');
      final response = await http.get(url);
      if (response.statusCode == 200 ) {
        final otpUrl = Uri.parse(
            "https://2factor.in/API/V1/$apiKey/SMS/+91$number/AUTOGEN");

        final otpResponse = await http.get(otpUrl);

        if (otpResponse.statusCode == 200) {
          final sessionId = RegExp(r'"Details":"(.*?)"')
              .firstMatch(otpResponse.body)
              ?.group(1);

          if (sessionId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Otp(number: number, sessionId: sessionId),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send OTP")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mobile number not found")),
        );
      }
    }


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,),
      body: Column(
        children: [
          Center(
            child: Image.asset(
              AppImages.verify,
              height: 170,
              width: 250,
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                  'Forget Password!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),

          const SizedBox(height: 8),
          Text(
            'Enter your registered mobile number will be send Verification code',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
              ],
            ),
          ),
          Form(
            key: _formkey,
            child: Container(
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white30),
              ),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: number,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Phone Number",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Iconsax.call, color: Colors.white70),
                ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your phone number';
                    if (value.length != 10) return 'Phone number must be 10 digits';
                    return null;
                  }
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if(_formkey.currentState!.validate()){
                checkNumberAndSendOtp(number.text);
              }
              else{
                print('Not working');
              }
            },
            child: Container(
              margin: EdgeInsets.all(20.0),
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
                child: Text(
                  "Continue",
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
    );
  }
}
