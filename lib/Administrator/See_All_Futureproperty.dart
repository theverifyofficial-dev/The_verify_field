import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../ui_decoration_tools/constant.dart';
import 'Future_property_details.dart';

class Catid {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String BHK;
  final String tyope;
  final String floor_ ;
  final String buy_Rent ;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String property_address_for_fieldworkar;
  final String date;

  Catid(
      {required this.id, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.BHK, required this.tyope, required this.floor_, required this.buy_Rent,
        required this.Building_information,required this.Ownername,required this.Owner_number, required this.Caretaker_name,required this.Caretaker_number,required this.vehicleNo,required this.property_address_for_fieldworkar,required this.date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        Building_Address: json['propertyname_address'],
        Building_Location: json['place'],
        Building_image: json['images'],
        Longitude: json['longitude'],
        Latitude: json['latitude'],
        BHK: json['select_bhk'],
        tyope: json['typeofproperty'],
        floor_: json['floor_number'],
        buy_Rent: json['buy_rent'],
        Building_information: json['building_information_facilitys'],
        Ownername: json['ownername'],
        Owner_number: json['ownernumber'],
        Caretaker_name: json['caretakername'],
        Caretaker_number: json['caretakernumber'],
        vehicleNo: json['owner_vehical_number'],
        property_address_for_fieldworkar: json['property_address_for_fieldworkar'],
        date: json['current_date_']);
  }
}



class SeeAll_FutureProperty extends StatefulWidget {
  String id;
  SeeAll_FutureProperty({super.key, required this.id});

  @override
  State<SeeAll_FutureProperty> createState() => _SeeAll_FuturePropertyState();
}

class _SeeAll_FuturePropertyState extends State<SeeAll_FutureProperty> {

  String _number = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=${widget.id}");
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
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
        actions:  [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: SingleChildScrollView(
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
                    physics: NeverScrollableScrollPhysics(),
                    //scrollDirection: Axis.vertical,
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
                                prefs.setString('id_Latitude', abc.data![len].Latitude.toString());*/
                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => Future_Property_details(idd: '${abc.data![len].id.toString()}',))
                          );
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                          child: Container(
                                            width: size.width,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              //https://verifyserve.social/PHP_Files/future_property_insert_api/

                                              "https://verifyserve.social/PHP_Files/future_property/"+abc.data![len].Building_image,
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) => Image.asset(
                                                AppImages.loading,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget: (context, error, stack) =>
                                                  Image.asset(
                                                    AppImages.imageNotFound,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                      ],
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Row(
                                          children: [

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
                                                  Text(""+abc.data![len].BHK/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                  //w SizedBox(width: 10,),
                                                  Text(""+abc.data![len].buy_Rent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                  //w SizedBox(width: 10,),
                                                  Text(""+abc.data![len].Building_Location/*+abc.data![len].Building_Name.toUpperCase()*/,
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




                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Property Address Feildworker",
                                              style: TextStyle(
                                                  fontSize: 15,
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
                                            SizedBox(
                                              width: 300,
                                              child: Text(""+abc.data![len].property_address_for_fieldworkar,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),


                                        SizedBox(
                                          width: 10,
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
                                              //w SizedBox(width: 10,),
                                              Text(""+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
      _number = prefs.getString('number') ?? '';
    });
  }

}
