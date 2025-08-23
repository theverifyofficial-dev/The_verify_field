import 'dart:convert';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Catid {
  final int id;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String demand_name;
  final String demand_number;
  final String buy_rent;
  final String place;

  Catid(
      {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
        required this.buy_rent, required this.place});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        fieldworkar_name: json['fieldworkar_name'],
        fieldworkar_number: json['fieldworkar_number'],
        demand_name: json['demand_name'],
        demand_number: json['demand_number'],
        buy_rent: json['buy_rent'],
        place: json['add_info']);
  }
}

class Pending_monthend extends StatefulWidget {
  const Pending_monthend({super.key});

  @override
  State<Pending_monthend> createState() => _Pending_monthendState();
}

class _Pending_monthendState extends State<Pending_monthend> {

  Future<List<Catid>> fetchData_pendinhg(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_assign_tenant_demand_by_feild_num_looking_location_?fieldworkar_number=$_num&looking_type=Month&location_=$_location');
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

  String _num = '';
  String _na = '';
  String _location = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: FutureBuilder<List<Catid>>(
          future: fetchData_pendinhg(""+1.toString()),
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
                  itemCount: abc.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context,int len){
                    return GestureDetector(
                      onTap: () async {
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
                                          border: Border.all(width: 1, color: Colors.black),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.5),
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
                                          border: Border.all(width: 1, color: Colors.black),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.5),
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
                                            Text(""+abc.data![len].place/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                            //w SizedBox(width: 10,),
                                            Text(""+abc.data![len].demand_name/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                              Icon(Iconsax.call,size: 15,color: Colors.red,),
                                              SizedBox(width: 4,),
                                              Text(""+abc.data![len].demand_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                    height: 10,
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
