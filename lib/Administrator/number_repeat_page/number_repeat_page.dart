import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../ui_decoration_tools/app_images.dart';
import '../Add_Assign_Tenant_Demand/Add_Assign_Demand_form.dart';
import '../Administrator_main_tenantdemand.dart';
import '../Pending_demand_Status.dart';


class add_repet_num extends StatefulWidget {
  const add_repet_num({super.key});

  @override
  State<add_repet_num> createState() => _add_repet_numState();
}

class _add_repet_numState extends State<add_repet_num> {

  final TextEditingController _number = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<TenantModel>> fetchData() async {
    String finalNumber = normalizePhoneNumber(_number.text);

    var url = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/Verify_Tenant_show_by_V_number_?V_number=$finalNumber'
    );
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => TenantModel.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  String normalizePhoneNumber(String input) {
    // Remove everything except digits
    String number = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove country code if present
    if (number.startsWith('91') && number.length > 10) {
      number = number.substring(number.length - 10);
    }

    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIconsRegular.caretLeft,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
              padding: EdgeInsets.only(left: 15, top: 20, right: 10),
              child: Text('Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

          SizedBox(height: 5,),

          Builder(
            builder: (context) {
              return Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _number,
                    keyboardType: TextInputType.phone,
                    maxLength: 13,

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Number is required';
                      }

                      String normalized = normalizePhoneNumber(value);

                      if (normalized.length != 10) {
                        return 'Enter valid 10 digit number';
                      }

                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      counterText: "", // hide maxLength counter
                      prefixIcon: Icon(Icons.phone, color: Colors.red),
                      hintText: "Enter 10-digit phone number",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                      border: InputBorder.none,
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(
            height: 20,
          ),

          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
              ),
              onPressed: () async {
                //fetchData();

                if (_formKey.currentState?.validate() == true) {

                  String finalNumber = normalizePhoneNumber(_number.text);

                  final responce_Official_table = await http.get(Uri.parse("https://verifyrealestateandservices.in/WebService4.asmx/countapi_by_demand_number_assign_tenant_demand?demand_number=$finalNumber"));

                  final responce_Official_table_SECOND = await http.get(Uri.parse("https://verifyrealestateandservices.in/WebService4.asmx/countapi_by_demand_no_assign_tanant_demand_2nd_table?demand_number=$finalNumber"));

                  final responce_Official_Maintable = await http.get(Uri.parse("https://verifyrealestateandservices.in/WebService4.asmx/Verify_Tenant_Countapi_by_V_number_?V_number=$finalNumber"));


                  print(responce_Official_table.body);
                  print(responce_Official_table_SECOND.body);
                  print(responce_Official_Maintable.body);

                  if (responce_Official_table.body == '[{"logg":0}]' && responce_Official_table_SECOND.body == '[{"logg":0}]' && responce_Official_Maintable.body == '[{"logg":0}]') {

                    //fetchData();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  assign_demand_form(A_num: finalNumber,)));
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => assign_demand_form(num: '${_number.text}',),), (route) => route.isFirst);

                    // Successful login
                    //
                    // print("Login successful");
                  } else {
                    // Failed login

                    Fluttertoast.showToast(
                        msg: "Number Found in Tenant Demand table",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );

                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Pending_demand_Status(id: finalNumber,),), (route) => route.isFirst);

                  }

                } else {
                  print("bekar");
                }



              }, child: Text("Next", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20 ),
            ),
            ),
          ),

        ],
      ),
    );
  }
}
