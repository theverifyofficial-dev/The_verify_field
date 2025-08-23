import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../constant.dart';
import 'Add_TenantDemands.dart';
import 'Assigned_demand_Add_MainTenant_Demand.dart';
import 'Feild_Accpte_TenantDemand.dart';
import 'Parent_class_TenantDemand.dart';
import 'Tenant_demands_details.dart';

class Catid {
  final int id;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String demand_name;
  final String demand_number;
  final String buy_rent;
  final String place;
  final String refrance;
  final String BHK;
  final String location_;

  Catid(
      {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
        required this.buy_rent, required this.place, required this.refrance, required this.BHK, required this.location_});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        fieldworkar_name: json['fieldworkar_name'],
        fieldworkar_number: json['fieldworkar_number'],
        demand_name: json['demand_name'],
        demand_number: json['demand_number'],
        buy_rent: json['buy_rent'],
        place: json['add_info'],
        refrance: json['reference'],
        BHK: json['bhk'],
        location_: json['location_']);
  }
}

class Assignd_Tenant_details extends StatefulWidget {
  const
  Assignd_Tenant_details({super.key});

  @override
  State<Assignd_Tenant_details> createState() => _Assignd_Tenant_detailsState();
}

class _Assignd_Tenant_detailsState extends State<Assignd_Tenant_details> {

  String _date = '';
  String _Time = '';

  void _generateDateTime() {
    setState(() {
      _Time = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _date = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/show_assign_tanant_demand_2nd_table');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> Deletedemand(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/delete_assign_tanant_demand_2nd_table_by_id?id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      /*setState(() {
        _isDeleting = false;
        //ShowVehicleNumbers(id);
        //showVehicleModel?.vehicleNo;
      });*/
      print(response.body.toString());
      print('Item deleted successfully');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  String _location = '';

  Future<void> insurtMaintable(FN,FNO,Name,Number,buyrent,Additional_Info,refrence,bhk,date,time) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/add_assign_tenant_demand_?fieldworkar_name=$FN&fieldworkar_number=$FNO&demand_name=$Name&demand_number=$Number&buy_rent=$buyrent&add_info=$Additional_Info&location_=$_location&reference=$refrence&feedback=blank&looking_type=Pending&bhk=$bhk&dates=$date&times=$time'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Administater_parent_TenandDemand(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration${responce.statusCode}');
    }

  }

  String _num = '';
  String _na = '';

  late String formattedDate;
  late String formattedTime;

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<List<Catid>>(
            future: fetchData(),
            builder: (context,abc) {
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
              else {
                return ListView.builder(
                    itemCount: abc.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,int len){
                      int displayIndex = abc.data!.length - len;
                      return GestureDetector(
                        onTap: () async {
                          //fetchdata_accpte('${abc.data![len].id}', _na, _num);
                          // print("object_hellooo");
                          //  int itemId = abc.data![len].id;
                          //int iiid = abc.data![len].PropertyAddress
                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('id_Document', abc.data![len].id.toString());*/
                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setInt('id_Building', abc.data![len].id);
                              prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                              prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute
                                    (builder: (context) => Tenant_Demands_details())
                              );*/
                          /*Navigator.push(
                                  context,
                                  MaterialPageRoute
                                    (builder: (context) => Add_Assigned_TenantDemands())
                              );*/
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
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [



                                        SizedBox(
                                          height: 10,
                                        ),


                                        Row(
                                          children: [
                                            Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text(" Name",
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

                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 1, color: Colors.deepOrange),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.deepOrange.withOpacity(0.5),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0),
                                                  blurStyle: BlurStyle.outer
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              // Icon(Iconsax.sort_copy,size: 15,),
                                              //w SizedBox(width: 10,),
                                              Text(""+abc.data![len].demand_name/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        /*Row(
                                          children: [
                                            Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text(" Number",
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

                                        GestureDetector(
                                          onTap: (){

                                            showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Call "+abc.data![len].demand_name),
                                                content: Text('Do you really want to Call? '+abc.data![len].demand_name ),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                actions: <Widget>[
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Text('No'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      FlutterPhoneDirectCaller.callNumber('${abc.data![len].demand_number}');
                                                    },
                                                    child: Text('Yes'),
                                                  ),
                                                ],
                                              ),
                                            ) ?? false;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: 1, color: Colors.pinkAccent),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.pinkAccent.withOpacity(0.5),
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
                                                Text(""+abc.data![len].demand_number*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.5
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),*/



                                        SizedBox(
                                          height: 10,
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
                                                children: [
                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                  //SizedBox(width: 10,),
                                                  Text(""+abc.data![len].buy_rent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                    style: TextStyle(
                                                        fontSize: 16,
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
                                                border: Border.all(width: 1, color: Colors.brown),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.brown.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].BHK/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                    style: TextStyle(
                                                        fontSize: 16,
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
                                            SizedBox(width: 10,),
                                            Container(
                                              width: 300,
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.orangeAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.orangeAccent.withOpacity(0.5),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 0),
                                                      blurStyle: BlurStyle.outer
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                  //w SizedBox(width: 10,),
                                                  Text(""+abc.data![len].place,maxLines: 3,/*+abc.data![len].Building_Name.toUpperCase()*/
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

                                            Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.indigoAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.indigoAccent.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].fieldworkar_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                  Text(""+abc.data![len].fieldworkar_name/*+abc.data![len].Building_Name.toUpperCase()*/,
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


                                          ],
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          children: [

                                            Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.redAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.redAccent.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].location_/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                            SizedBox(width: 10,),

                                            Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.redAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.redAccent.withOpacity(0.5),
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
                                                  Text("Demand No = $displayIndex"/*+abc.data![len].Building_Name.toUpperCase()*/,
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


                                          ],
                                        ),


                                        SizedBox(
                                          height: 10,
                                        ),


                                        GestureDetector(
                                          onTap: () {

                                            DateTime now = DateTime.now();
                                            formattedDate = "${now.day}/${now.month}/${now.year}";
                                            formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                            _generateDateTime();

                                            insurtMaintable(_na,_num,abc.data![len].demand_name,abc.data![len].demand_number,abc.data![len].buy_rent,abc.data![len].place,abc.data![len].refrance,abc.data![len].BHK,_date,_Time);

                                            Deletedemand(abc.data![len].id);
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => parent_TenandDemand(),), (route) => route.isFirst);
                                            //fetchdata_accpte('${abc.data![len].id}', _na, _num);
                                            //print("object_hellooo");
                                            /*Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => Edit_Optionin_Demand(id: '${abc.data![len].id.toString()}', name: '${abc.data![len].demand_name}', number: '${abc.data![len].demand_number}', info: '${abc.data![len].info}', buy: '${abc.data![len].buy_rent}', referenc: '${abc.data![len].refrence}'))
                                            );*/
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 40,
                                              padding: const EdgeInsets.symmetric(horizontal: 40),
                                              decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),
                                                      bottomRight: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10)),
                                                  color: Colors.red.withOpacity(0.8)),
                                              child: Center(
                                                child: Text(
                                                  "Accept",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.8,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
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

                      Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),);



                    });
              }


            }

        ),
      ),


    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _na = prefs.getString('name') ?? '';
      _num = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
    });
  }


}
