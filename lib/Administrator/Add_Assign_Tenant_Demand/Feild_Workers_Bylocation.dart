import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import 'Add_Assign_Demand_form.dart';

class Catid {
  final String F_Name;
  final String F_Number;
  final String FAadharCard;

  Catid(
      {required this.F_Name, required this.F_Number, required this.FAadharCard});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
        F_Name: json['FName'],
        F_Number: json['FNumber'],
        FAadharCard: json['FAadharCard']);
  }
}

class FeildWorker_by_Location extends StatefulWidget {
  const FeildWorker_by_Location({super.key});

  @override
  State<FeildWorker_by_Location> createState() => _FeildWorker_by_LocationState();
}

class _FeildWorker_by_LocationState extends State<FeildWorker_by_Location> {

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Display_FeildWorkers_Register_by_location?F_Location=Sultanpur");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  String _location = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
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
            Navigator.pop(context, true);

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
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));
            },
            child: const Icon(
              PhosphorIcons.trash,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Container(
        child: FutureBuilder<List<Catid>>(
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
                    itemCount: abc.data!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context,int len){
                      return GestureDetector(
                        onTap: () async {
                          //  int itemId = abc.data![len].id;
                          //int iiid = abc.data![len].PropertyAddress
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          /*prefs.setString('id_Document', abc.data![len].id.toString());
                          prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                          prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                          prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                          prefs.setString('FLoorr', abc.data![len].floor_.toString());
                          prefs.setString('Flat', abc.data![len].Flat.toString());
                          prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                          prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());*/
                          //prefs.setString('Owner_no', abc.data![len].Owner_number.toString());
                          /*Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => assign_demand_form())
                          );*/

                          prefs.setString('FW_Name', abc.data![len].F_Name.toString());
                          prefs.setString('FW_Number', abc.data![len].F_Number.toString());

                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => assign_demand_form(A_num: '',))
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
                                    Row(
                                      children: [
                                        Icon(Iconsax.user_copy,size: 12,color: Colors.red,),
                                        SizedBox(width: 2,),
                                        Text("FeildWorker Name",
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
                                      width: 140,
                                      child: Text(
                                        abc.data![len].F_Name.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Iconsax.mobile_copy,size: 12,color: Colors.red,),
                                        SizedBox(width: 2,),
                                        Text("FeildWorker Number",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text('+91 '+abc.data![len].F_Number,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400
                                      ),
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


      ),

    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _location = prefs.getString('location') ?? '';
    });
  }
}
