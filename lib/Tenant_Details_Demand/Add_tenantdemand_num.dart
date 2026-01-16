import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../Custom_Widget/constant.dart';
import 'Add_TenantDemands.dart';
import 'SHow_Add_Demand_Data.dart';

class Catid {
  final int id;
  final String V_name;
  final String V_number;
  final String bhk;
  final String budget;
  final String place;
  final String floor_option;
  final String Additional_Info;
  final String Shifting_date;
  final String Current_date;
  final String Parking;
  final String Gadi_Number;
  final String FeildWorker_Name;
  final String FeildWorker_Number;
  final String Current__Date;
  final String Family_Members;
  final String buyrent;

  Catid(
      {required this.id, required this.V_name, required this.V_number, required this.bhk, required this.budget,
        required this.place, required this.floor_option, required this.Additional_Info, required this.Shifting_date,required this.Current_date,
        required this.Parking, required this.Gadi_Number, required this.FeildWorker_Name, required this.FeildWorker_Number,
        required this.Current__Date,required this.Family_Members,required this.buyrent});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['VTD_id'],
        V_name: json['V_name'],
        V_number: json['V_number'],
        bhk: json['bhk'],
        budget: json['budget'],
        place: json['place'],
        floor_option: json['floor_option'],
        Additional_Info: json['Additional_Info'],
        Shifting_date: json['Shifting_date'],
        Current_date: json['Current__Date'],
        Parking: json['Parking'],
        Gadi_Number: json['Gadi_Number'],
        FeildWorker_Name: json['FeildWorker_Name'],
        FeildWorker_Number: json['FeildWorker_Number'],
        Current__Date: json['Current__Date'],
        Family_Members: json['Family_Members'],
        buyrent: json['Buy_rent']);
  }
}

class add_Tenant_num extends StatefulWidget {
  const add_Tenant_num({super.key});

  @override
  State<add_Tenant_num> createState() => _add_Tenant_numState();
}

class _add_Tenant_numState extends State<add_Tenant_num> {

  final TextEditingController _number = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Tenant_show_by_V_number_?V_number=${_number.text}');
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
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
                PhosphorIcons.caret_left_bold,
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

          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                // boxShadow: K.boxShadow,
              ),
              child: TextFormField(
                controller: _number,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number is required';
                  } else if (value.length != 10) {
                    return 'Enter exactly 10 digits';
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
                // First validate form
                if (!_formKey.currentState!.validate()) {
                  Fluttertoast.showToast(
                    msg: "Enter a valid 10-digit number",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return; // Stop here if invalid
                }

                // Proceed if valid
                final response = await http.get(Uri.parse(
                    "https://verifyserve.social/WebService4.asmx/Verify_Tenant_Countapi_by_V_number_?V_number=${_number.text}"));

                print(response.body);

                if (response.body == '[{"logg":0}]') {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Add_TenantDemands(
                        number_Back: _number.text,
                        pending_id: '0',
                      ),
                    ),
                        (route) => route.isFirst,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Number Found in Tenant Demand table",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Show_AddedDemand_Details(
                        id: _number.text,
                      ),
                    ),
                        (route) => route.isFirst,
                  );
                }
              },
              child: Text("Next", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20 ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
