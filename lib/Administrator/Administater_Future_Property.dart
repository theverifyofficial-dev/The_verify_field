import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../ui_decoration_tools/constant.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';

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
  final String date;

  Catid(
      {required this.id, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.BHK, required this.tyope, required this.floor_, required this.buy_Rent,
        required this.Building_information,required this.Ownername,required this.Owner_number, required this.Caretaker_name,required this.Caretaker_number,required this.vehicleNo,required this.date});

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
        date: json['current_date_']);
  }
}

class ADministaterShow_FutureProperty extends StatefulWidget {
  const ADministaterShow_FutureProperty({super.key});

  @override
  State<ADministaterShow_FutureProperty> createState() => _ADministaterShow_FuturePropertyState();
}

class _ADministaterShow_FuturePropertyState extends State<ADministaterShow_FutureProperty> {

  void _showBottomSheet(BuildContext context) {

    List<String> timing = [
      "Residential",
      "Plots",
      "Commercial",
    ];
    ValueNotifier<int> timingIndex = ValueNotifier(0);

    String displayedData = "Press a button to display data";

    void updateData(String newData) {
      setState(() {
        displayedData = newData;
      });
    }

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5,top: 0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      Tab(text: 'Residential'),
                      Tab(text: 'Commercial'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Filter_Options(),
                    Commercial_Filter()
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String _number = '';

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9711775300");
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

  Future<List<Catid>> fetchData1() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9711275300");
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

  Future<List<Catid>> fetchData2() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9971172204");
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
  void initState() {
    _loaduserdata();
    super.initState();

  }

  bool _isDeleting = false;

  //Delete api
  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      setState(() {
        _isDeleting = false;
        //ShowVehicleNumbers(id);
        //showVehicleModel?.vehicleNo;
      });
      print(response.body.toString());
      print('Item deleted successfully');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.black,
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
        // actions:  [
        //   GestureDetector(
        //     onTap: () {
        //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Filter_Options()));
        //       _showBottomSheet(context);
        //     },
        //     child: const Icon(
        //       PhosphorIcons.faders,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),
      body: CustomScrollView(
        slivers: [

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sumit kasaniya',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9711775300',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 650,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context,int len) {
                                int displayIndex = abc.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                          context,
                                          MaterialPageRoute
                                            (builder: (context) => Administater_Future_Property_details(idd: '${abc.data![len].id}',))
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
                                                      height: 400,
                                                      width: 310,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
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
                                                            Text(""+abc.data![len].tyope/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            Text(""+abc.data![len].floor_/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Owner Name | Owner Number",
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
                                                        width: 5,
                                                      ),
                                                      Row(
                                                        children: [
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
                                                                Text(""+abc.data![len].Ownername/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        width: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){

                                                              showDialog<bool>(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  title: Text('Call Property Owner'),
                                                                  content: Text('Do you really want to Call Owner?'),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      onPressed: () => Navigator.of(context).pop(false),
                                                                      child: Text('No'),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        FlutterPhoneDirectCaller.callNumber('${abc.data![len].Owner_number}');
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
                                                                  Text(""+abc.data![len].Owner_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Property Address",
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
                                                      SizedBox(
                                                        width: 300,
                                                        child: Text(""+abc.data![len].Building_Address,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 10,
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
                                                            //SizedBox(width: 10,),
                                                            Text(""+abc.data![len].date/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    height: 10,
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
                                                            Text("Property No = $displayIndex"/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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
                                                            Text("Property id = "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData1(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Ravi Kumar',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData1();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9711275300',)));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            //height: size.height,
                            height: 650,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context,int len) {
                                int displayIndex = abc.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_Future_Property_details(idd: '${abc.data![len].id}',))
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
                                                      height: 400,
                                                      width: 310,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
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
                                                            Text(""+abc.data![len].tyope/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            Text(""+abc.data![len].floor_/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Owner Name | Owner Number",
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
                                                        width: 5,
                                                      ),
                                                      Row(
                                                        children: [
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
                                                                Text(""+abc.data![len].Ownername/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        width: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){

                                                              showDialog<bool>(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  title: Text('Call Property Owner'),
                                                                  content: Text('Do you really want to Call Owner?'),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      onPressed: () => Navigator.of(context).pop(false),
                                                                      child: Text('No'),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        FlutterPhoneDirectCaller.callNumber('${abc.data![len].Owner_number}');
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
                                                                  Text(""+abc.data![len].Owner_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Property Address",
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
                                                      SizedBox(
                                                        width: 300,
                                                        child: Text(""+abc.data![len].Building_Address,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 10,
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
                                                            //SizedBox(width: 10,),
                                                            Text(""+abc.data![len].date/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    height: 10,
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
                                                            Text("Property No = $displayIndex"/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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
                                                            Text("Property id = "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData2(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Faizan khan',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData2();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9971172204',)));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 650,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context,int len) {
                                int displayIndex = abc.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_Future_Property_details(idd: '${abc.data![len].id}',))
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
                                                      height: 400,
                                                      width: 310,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
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
                                                            Text(""+abc.data![len].tyope/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            Text(""+abc.data![len].floor_/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Owner Name | Owner Number",
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
                                                        width: 5,
                                                      ),
                                                      Row(
                                                        children: [
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
                                                                Text(""+abc.data![len].Ownername/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        width: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: (){

                                                              showDialog<bool>(
                                                                context: context,
                                                                builder: (context) => AlertDialog(
                                                                  title: Text('Call Property Owner'),
                                                                  content: Text('Do you really want to Call Owner?'),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                  actions: <Widget>[
                                                                    ElevatedButton(
                                                                      onPressed: () => Navigator.of(context).pop(false),
                                                                      child: Text('No'),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed: () async {
                                                                        FlutterPhoneDirectCaller.callNumber('${abc.data![len].Owner_number}');
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
                                                                  Text(""+abc.data![len].Owner_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Property Address",
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
                                                      SizedBox(
                                                        width: 300,
                                                        child: Text(""+abc.data![len].Building_Address,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 10,
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
                                                            //SizedBox(width: 10,),
                                                            Text(""+abc.data![len].date/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    height: 10,
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
                                                            Text("Property No = $displayIndex"/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                                      SizedBox(width: 10,),

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
                                                            Text("Property id = "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

        ],
      ),

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

}
