import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../ui_decoration_tools/app_images.dart';
import '../Add_Assign_Tenant_Demand/Add_Assign_Demand_form.dart';
import '../Pending_demand_Status.dart';

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

class add_repet_num extends StatefulWidget {
  const add_repet_num({super.key});

  @override
  State<add_repet_num> createState() => _add_repet_numState();
}

class _add_repet_numState extends State<add_repet_num> {

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
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
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
                    keyboardType: TextInputType.number,
                    maxLength: 10, // restrict input to 10 digits
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
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


                  final responce_Official_table = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/countapi_by_demand_number_assign_tenant_demand?demand_number=${_number.text}"));

                  final responce_Official_table_SECOND = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/countapi_by_demand_no_assign_tanant_demand_2nd_table?demand_number=${_number.text}"));

                  final responce_Official_Maintable = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/Verify_Tenant_Countapi_by_V_number_?V_number=${_number.text}"));


                  print(responce_Official_table.body);
                  print(responce_Official_table_SECOND.body);
                  print(responce_Official_Maintable.body);

                  if (responce_Official_table.body == '[{"logg":0}]' && responce_Official_table_SECOND.body == '[{"logg":0}]' && responce_Official_Maintable.body == '[{"logg":0}]') {

                    //fetchData();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  assign_demand_form(A_num: '${_number.text}',)));
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

                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Pending_demand_Status(id: '${_number.text}',),), (route) => route.isFirst);

                  }

                } else {
                  print("bekar");
                }


                /*if (responce_Assign_Table.body == '[{"logg":1}]') {

                  Fluttertoast.showToast(
                      msg: "Number Found in Assign table",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  // Successful login
                  print("Login successful");
                } else {
                  // Failed login
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Add_TenantDemands(number_Back: '${_number.text}',),), (route) => route.isFirst);

                }*/



              }, child: Text("Next", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20 ),
            ),
            ),
          ),

          /*FutureBuilder<List<Catid>>(
              future: fetchData(),
              builder: (context,abc){
                if(abc.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else if(abc.hasError){
                  return Text('${abc.error}');
                }
                else if (abc.data == null || abc.data!.isEmpty) {
                  // If the list is empty, show an empty image
                  return Center(
                    child: Column(
                      children: [
                        // Lottie.asset("assets/images/no data.json",width: 450),
                        Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                      ],
                    ),
                  );
                }
                else{
                  return ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context,int len){
                        return GestureDetector(
                          onTap: () async {
                            //  int itemId = abc.data![len].id;
                            //int iiid = abc.data![len].PropertyAddress
                            */
          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('id_Document', abc.data![len].id.toString());*/
          /*
                            */
          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', abc.data![len].id);
                                prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                                prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute
                                      (builder: (context) => Tenant_Demands_details())
                                );*/
          /*



                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 5,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.greenAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                    SizedBox(width: 2,),
                                                    Text(""+abc.data![len].bhk*/
          /*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.greenAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(""+abc.data![len].buyrent*//*+abc.data![len].Building_Name.toUpperCase()*/
          /*,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.greenAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(""+abc.data![len].place*/
          /*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                            children: [
                                              Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text(" Name | Number",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.red),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.red.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].V_name*//*+abc.data![len].Building_Name.toUpperCase()*/
          /*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),

                                              GestureDetector(
                                                onTap: (){

                                                  */
          /*  showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Call "+abc.data![len].V_name),
                                                          content: Text('Do you really want to Call? '+abc.data![len].V_name ),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].V_number}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;*/
          /*
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.red),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.red.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                      SizedBox(width: 4,),
                                                      Text(""+abc.data![len].V_number*/
          /*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text("Type Of Requirement / Floor Options",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].bhk*//*+abc.data![len].Building_Name.toUpperCase()*/
          /*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].floor_option*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),





                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(PhosphorIcons.car,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text("Need Parking / Vehicle Number",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.cyanAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.cyanAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].Parking*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),




                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.cyanAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.cyanAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].Gadi_Number.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),





                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Icon(PhosphorIcons.users_four,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              SizedBox(
                                                width: 100,
                                                child: Text("Family Members = ",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                width: 100,
                                                child: Text(""+abc.data![len].Family_Members+" Members",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text("Additional Information",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(""+abc.data![len].Additional_Info,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                            children: [
                                              Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text("Budget / Shifting Date",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),

                                          Row(
                                            children: [

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.blue),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.blue.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Icon(PhosphorIcons.currency_inr,size: 12,color: Colors.red,),
                                                    SizedBox(width: 2,),
                                                    Text(""+abc.data![len].budget*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.blue),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.blue.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].Shifting_date*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),

                                          SizedBox(height: 10,),

                                          Center(
                                            child: Text("Field Worker",style: TextStyle(fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),),
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(""+abc.data![len].FeildWorker_Name*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),

                                              GestureDetector(
                                                onTap: (){

                                                  *//* showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('Call Feild Worker'),
                                                          content: Text('Do you really want to Call Feild Worker?'),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].FeildWorker_Number}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;*//*
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(width: 1, color: Colors.purple),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.purple.withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle: BlurStyle.outer
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(""+abc.data![len].FeildWorker_Number*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),

                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.lightGreenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.lightGreenAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text("Tenant id =  "+abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(
                                                width: 10,
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.lightGreenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.lightGreenAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].Current_date.toString()*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),



                                        ],
                                      ),


                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                }


              }

          ),*/

        ],
      ),
    );
  }
}
