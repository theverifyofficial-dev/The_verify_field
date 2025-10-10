import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Police_Verification/Property_Verify_Details.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_Property_Veerification.dart';
import 'Add_Tenant.dart';
import 'Show_tenant.dart';

class Catid {
  final int id;
  final String Flat;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String sqft;
  final String tyope;
  final String floor_ ;
  final String maintence ;
  final String buy_Rent ;
  final String Building_information;
  final String Parking;
  final String balcony;
  final String facility;
  final String Furnished;
  final String kitchen;
  final String Baathroom;
  final String Ownername;
  final String Owner_number;
  final String fieldworkarname;
  final String fieldworkarnumber;

  Catid(
      {required this.id, required this.Flat, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Ownername,required this.Owner_number,required this.fieldworkarname,required this.fieldworkarnumber});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['PVR_id'],
        Flat: json['flat_'],
        Building_Address: json['Address_'],
        Building_Location: json['Place_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        sqft: json['City'],
        tyope: json['Typeofproperty'],
        floor_: json['floor_'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        Building_information: json['Building_information'],
        balcony: json['balcony'],
        Parking: json['Parking'],
        facility: json['Lift'],
        Furnished: json['Furnished'],
        kitchen: json['kitchen'],
        Baathroom: json['Baathroom'],
        Ownername: json['Ownername'],
        Owner_number: json['Owner_number'],
        fieldworkarname: json['fieldworkarname'],
        fieldworkarnumber: json['fieldworkarnumber']);
  }
}

class Book_Property extends StatefulWidget {
  const Book_Property({super.key});

  @override
  State<Book_Property> createState() => _Book_PropertyState();
}

class _Book_PropertyState extends State<Book_Property> {

  String _number = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  Future<List<Catid>> fetchData(id) async{

    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/show_propertyverifycation_by_lookingproperty_fieldworkarnumber?Looking_Property_=Book&fieldworkarnumber=$_number");
    final responce=await http.get(url);
    if(responce.statusCode==200){

      List listresponce=json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));

      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else{
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
            future: fetchData(""+1.toString()),
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
                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('id_Subid', abc.data![len].id.toString());
                          prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                          prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                          prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                          prefs.setString('FLoorr', abc.data![len].floor_.toString());
                          prefs.setString('Flat', abc.data![len].Flat.toString());
                          prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                          prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());
                          prefs.setString('fieldworkarname', abc.data![len].fieldworkarname.toString());
                          prefs.setString('fieldworkarnumber', abc.data![len].fieldworkarnumber.toString());
                          prefs.setString('property_image', abc.data![len].Building_image.toString());
                          prefs.setString('maintence', abc.data![len].maintence.toString());
                          prefs.setString('bhk_bhk', abc.data![len].BHK.toString());
                          //prefs.setString('Owner_no', abc.data![len].Owner_number.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => TenantDetails())
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
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              const BorderRadius.all(Radius.circular(10)),
                                              child: Container(
                                                height: 90,
                                                width: 120,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  "https://verifyserve.social/"+abc.data![len].Building_image,
                                                  fit: BoxFit.cover,
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
                                            SizedBox(height: 5,),
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
                                                  Text(""+abc.data![len].tyope.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 12,
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
                                        SizedBox(width: 5,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Property Address",
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
                                              width: 180,
                                              child: Text(""+abc.data![len].Building_Address,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
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
                                                Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Society",
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
                                              width: 180,
                                              child: Text(""+abc.data![len].Building_Location,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Place",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 180,
                                              child: Text(""+abc.data![len].balcony
                                                ,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Iconsax.building_3_copy,size: 14,color: Colors.red,),
                                                SizedBox(width: 3,),
                                                Text(""+abc.data![len].BHK.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey.shade600,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => Property_Verify_Details(id: '${abc.data![len].id.toString()}',))
                                            );
                                            /*Navigator.push(
                                            context,
                                            MaterialPageRoute
                                              (builder: (context) => Add_Assigned_TenantDemands(id: '${abc.data![len].id.toString()}', name: '${abc.data![len].demand_name.toString()}', number: '${abc.data![len].demand_number.toString()}', buyrent: '${abc.data![len].buy_rent.toString()}',))
                                        );*/
                                          },
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10)),
                                                color: Colors.red.withOpacity(0.8)),
                                            child: Center(
                                              child: Text(
                                                "View Details",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('id_Subid', abc.data![len].id.toString());
                                            prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                                            prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                                            prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                                            prefs.setString('FLoorr', abc.data![len].floor_.toString());
                                            prefs.setString('Flat', abc.data![len].Flat.toString());
                                            prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                                            prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());
                                            prefs.setString('fieldworkarname', abc.data![len].fieldworkarname.toString());
                                            prefs.setString('fieldworkarnumber', abc.data![len].fieldworkarnumber.toString());
                                            prefs.setString('property_image', abc.data![len].Building_image.toString());
                                            prefs.setString('maintence', abc.data![len].maintence.toString());
                                            prefs.setString('bhk_bhk', abc.data![len].BHK.toString());
                                            //prefs.setString('Owner_no', abc.data![len].Owner_number.toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => TenantDetails())
                                            );
                                            /*_showBottomSheet(context, "${abc.data![len].id.toString()}");
                                                  print("${abc.data![len].id}");*/

                                            /*Navigator.push(
                                            context,
                                            MaterialPageRoute
                                              (builder: (context) => Add_review_Under_feedback_T_Demand(idd: '${abc.data![len].id}',))
                                        );*/

                                          },
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 30),
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10)),
                                                color: Colors.red.withOpacity(0.8)),
                                            child: Center(
                                              child: Text(
                                                "Add Tenant",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.8,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),



                          ],
                        ),
                      );
                    });
              }


            }

        ),


      ),

      /*floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Property'),
        icon: Icon(Icons.add),
        onPressed: (){

          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: "/Page1"),
              builder: (context) => Add_Property_Verification(),
            ),
          );


          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => Add_Property()));
        },
      ),*/

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

}
