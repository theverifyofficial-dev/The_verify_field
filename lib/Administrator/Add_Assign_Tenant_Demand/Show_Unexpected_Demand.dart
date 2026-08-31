import 'dart:convert';
import 'package:flutter/material.dart';import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../number_repeat_page/number_repeat_page.dart';
import 'Edit_Asign_Demand.dart';

class Demand_model {
  final int id;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String demand_name;
  final String demand_number;
  final String buy_rent;
  final String place;
  final String info;
  final String refrence;
  final String BHK;

  Demand_model(
      {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
        required this.buy_rent, required this.place, required this.info, required this.refrence, required this.BHK});

  factory Demand_model.FromJson(Map<String, dynamic>json){
    return Demand_model(id: json['id'],
        fieldworkar_name: json['fieldworkar_name'],
        fieldworkar_number: json['fieldworkar_number'],
        demand_name: json['demand_name'],
        demand_number: json['demand_number'],
        buy_rent: json['buy_rent'],
        place: json['add_info'],
        info: json['add_info'],
        refrence : json['reference'],
        BHK: json['bhk']);
  }
}

class DemandModel2 {
  final int id;
  final String time;
  final String date;
  final String demandName;
  final String demandNumber;
  final String buyRent;
  final String addInfo;
  final String location;
  final String reference;
  final String feedback;
  final String lookingType;
  final String bhk;

  DemandModel2({
    required this.id,
    required this.time,
    required this.date,
    required this.demandName,
    required this.demandNumber,
    required this.buyRent,
    required this.addInfo,
    required this.location,
    required this.reference,
    required this.feedback,
    required this.lookingType,
    required this.bhk,
  });

  factory DemandModel2.fromJson(Map<String, dynamic> json) {
    return DemandModel2(
      id: int.tryParse(
        json['id']?.toString() ?? '',
      ) ??
          0,

      time: json['fieldworkar_name']?.toString() ?? '',

      date: json['fieldworkar_number']?.toString() ?? '',

      demandName:
      json['demand_name']?.toString() ?? '',

      demandNumber:
      json['demand_number']?.toString() ?? '',

      buyRent:
      json['buy_rent']?.toString() ?? '',

      addInfo:
      json['add_info']?.toString() ?? '',

      location:
      json['location_']?.toString() ?? '',

      reference:
      json['reference']?.toString() ?? '',

      feedback:
      json['feedback']?.toString() ?? '',

      lookingType:
      json['looking_type']?.toString() ?? '',

      bhk:
      json['bhk']?.toString() ?? '',
    );
  }
}

class Administater_Assignd_Tenant_details extends StatefulWidget {
  const Administater_Assignd_Tenant_details({super.key});

  @override
  State<Administater_Assignd_Tenant_details> createState() => _Administater_Assignd_Tenant_detailsState();
}

class _Administater_Assignd_Tenant_detailsState extends State<Administater_Assignd_Tenant_details> {



  late Future<List<DemandModel2>> _future;   // <-- add this

  Future<List<DemandModel2>> fetchData() async {
    final url = Uri.parse(
      'https://verifyrealestateandservices.in/'
          'WebService4.asmx/'
          'show_assign_tanant_demand_2nd_table',
    );

    try {
      final response = await http.get(url);

      debugPrint(
        "API STATUS: ${response.statusCode}",
      );

      if (response.statusCode != 200) {
        throw Exception(
          'API Error: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw Exception(
          'Unexpected API response format',
        );
      }

      final List<DemandModel2> result = [];

      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          result.add(
            DemandModel2.fromJson(item),
          );
        }
      }

      result.sort(
            (a, b) => a.id.compareTo(b.id), // ascending: oldest first, newest at bottom
      );

      return result;
    } catch (e, stackTrace) {
      debugPrint(
        "FETCH ERROR: $e",
      );

      debugPrint(
        "STACK: $stackTrace",
      );

      rethrow;
    }
  }

  String _num = '';
  String _na = '';

  @override
  void initState() {
    super.initState();
    _future = fetchData();   // <-- call ONCE here
    _loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,


      body: FutureBuilder<List<DemandModel2>>(
          future: _future,      // <-- use the stored future, not fetchData()
          builder: (context,abc) {
            if(abc.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else if(abc.hasError){
              return Text(
                '${abc.error}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              );
            }
            else if (abc.data == null || abc.data!.isEmpty) {
              // If the list is empty, show an empty image
              return const Center(
                child: Column(
                  children: [
                    // Lottie.asset("assets/images/no data.json",width: 450),
                    Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                  ],
                ),
              );
            }
            else {
              List<DemandModel2> displayList = abc.data!;

              return ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (BuildContext context,int len){
                    int displayIndex = len + 1;
                    return GestureDetector(
                      onTap: () async {
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                Text(displayList[len].buyRent,
                                                  style: const TextStyle(
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
                                                Text(displayList[len].bhk,
                                                  style: const TextStyle(
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
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.blueAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.blueAccent.withOpacity(0.5),
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
                                                  Text(displayList[len].demandName,
                                                    style: const TextStyle(
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

                                          SizedBox(
                                            width: 10,
                                          ),

                                          GestureDetector(
                                            onTap: (){

                                              showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("Call ${displayList[len].demandName}"),
                                                  content: Text('Do you really want to Call? ${displayList[len].demandName}' ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: Text('No'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        FlutterPhoneDirectCaller.callNumber(displayList[len].demandName);
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
                                                  const Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                  SizedBox(width: 4,),
                                                  Text(displayList[len].demandNumber,
                                                    style: const TextStyle(
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
                                                Text(displayList[len].location,maxLines: 3,
                                                  style: const TextStyle(
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
                                                Text(displayList[len].date,
                                                  style: const TextStyle(
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
                                                Text(displayList[len].time,
                                                  style: const TextStyle(
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

                                      Container(
                                        padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(width: 1, color: Colors.green),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.green.withOpacity(0.5),
                                                blurRadius: 10,
                                                offset: Offset(0, 0),
                                                blurStyle: BlurStyle.outer
                                            ),
                                          ],
                                        ),

                                        child: Row(
                                          children: [
                                            // Icon(Iconsax.sort_copy,size: 15,),
                                            //w SizedBox(width: 10,),-
                                            Text("Demand No = $displayIndex",
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) => Edit_Optionin_Demand(id: displayList[len].id.toString(), name: displayList[len].demandName, number: displayList[len].demandNumber, info: displayList[len].addInfo, buy: displayList[len].buyRent, referenc: displayList[len].reference))
                                          );
                                          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Persnol_Assignd_Tenant_details(),), (route) => route.isFirst);
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
                                            child: const Center(
                                              child: Text(
                                                "Edit",
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

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => add_repet_num()),
            );
          },
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle),
              SizedBox(width: 5),
              Text("New Demand", style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _na = prefs.getString('name') ?? '';
      _num = prefs.getString('number') ?? '';
    });
  }

}