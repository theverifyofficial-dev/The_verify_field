import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../Login_page.dart';


class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    TextEditingController number= TextEditingController();
    TextEditingController password= TextEditingController();

    Future<void> forget() async {
      String num = number.text;
      String pass = password.text;
      var url = Uri.parse('https://verifyserve.social/WebService4.asmx/ResetPassword?FNumber=$num&Password=$pass');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final message = data.first['Message']; // ✅ This is safe now

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? 'Successfully changed')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login_page()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed! Something went wrong')),
        );
      }
    }

    return SafeArea(child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black,),
        body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              child:
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const Text('Successfully OTP Verified',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                    const SizedBox(height: 20,),
                    const Text('Enter your mobile that associated with your account and we will send a OTP after confirmation you can reset your password',style: TextStyle(fontSize: 18,color: Colors.grey),),
                    const SizedBox(height: 100,),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20,),
                          TextFormField(
                            controller: number,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your number';
                              }
                              if (value.length != 10) return 'Phone number must be 10 digits';

                              return null;
                            },
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            // obscureText: true,//for hide password
                              controller: password,
                              decoration: InputDecoration(
                                labelText: 'New password',
                              ),
                              validator: (value)=> value!.isEmpty?'Please Enter the Password': null
                          ),
                          const SizedBox(height: 100,),
                          ElevatedButton(onPressed: (){
                            forget();
                          },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                            child: const Text('Confirm password',),
                          ),
                        ],
                      ),
                    ),
                  ]
              ),
            )
        )));
  }
}
