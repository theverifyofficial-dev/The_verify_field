import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Model.dart';

import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';

class Catid {
  final int id;
  final String property_num;
  final String Address_;
  final String Place_;
  final String sqft;
  final String Price;
  final String Sell_price;
  final String Persnol_price;
  final String maintenance;
  final String Buy_Rent;
  final String Residence_Commercial;
  final String floor_ ;
  final String flat_;
  final String Furnished;
  final String Details;
  final String Ownername;
  final String Owner_number;
  final String Building_information;
  final String balcony;
  final String kitchen;
  final String Baathroom;
  final String Parking;
  final String Typeofproperty;
  final String Bhk_Squarefit;
  final String Address_apnehisaabka;
  final String Caretaker_name;
  final String Caretaker_number;
  final String Building_Location;
  final String Building_Name;
  final String Building_Address;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String tyope;
  final String maintence ;
  final String buy_Rent ;
  final String facility;
  final String Feild_name ;
  final String Feild_number;
  final String date;

  Catid(
      {required this.id,required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number, required this.Building_Location, required this.Building_Name, required this.Building_Address, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.tyope, required this.maintence, required this.buy_Rent,
        required this.facility,required this.Feild_name,required this.Feild_number,required this.date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['PVR_id'],
        property_num: json['Property_Number'], Address_: json['Address_'],
        Place_: json['Place_'], sqft: json['City'],
        Price: json['Price'], Sell_price: json['Waterfilter'],
        Persnol_price: json['Gas_meter'], maintenance: json['maintenance'],
        Buy_Rent: json['Buy_Rent'], Residence_Commercial: json['Residence_Commercial'],
        floor_: json['floor_'], flat_: json['flat_'],
        Furnished: json['Furnished'], Details: json['Details'],
        Ownername: json['Ownername'], Owner_number: json['Owner_number'],
        Building_information: json['Building_information'], balcony: json['balcony'],
        kitchen: json['kitchen'], Baathroom: json['Baathroom'],
        Parking: json['Parking'], Typeofproperty: json['Typeofproperty'],
        Bhk_Squarefit: json['Bhk_Squarefit'], Address_apnehisaabka: json['Address_apnehisaabka'],
        Caretaker_name: json['Water_geyser'], Caretaker_number: json['CareTaker_number'], Building_Location: json['Place_'],
        Building_Name: json['Building_information'],
        Building_Address: json['Address_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        tyope: json['Typeofproperty'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        facility: json['Lift'],
        Feild_name: json['fieldworkarname'],
        Feild_number: json['fieldworkarnumber'],
        date: json['date_']);
  }
}


class View_Details_Payment extends StatefulWidget {
  String id;
  View_Details_Payment({super.key, required this.id});

  @override
  State<View_Details_Payment> createState() => _View_Details_PaymentState();
}

class _View_Details_PaymentState extends State<View_Details_Payment> {

  Future<List<RealEstateSlider>> fetchCarouselData() async {
    final response = await http.get(Uri.parse(
        'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$_id'));

    if (response.statusCode == 200) {
      // Extract JSON string from XML SOAP response
      final decodedXml = jsonDecode(response.body);
      final jsonString = decodedXml['d']; // assuming JSON is under key 'd'
      final List<dynamic> data = jsonDecode(jsonString);

      return data.map((item) => RealEstateSlider.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load carousel data');
    }
  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.id}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  // final result = await fetchData();

  List<String> name = [];

  // late final int iid;

  int _id = 0;

  @override
  void initState() {
    super.initState();
    _loaduserdata();

  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

//  final result = await profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
        actions:  [
          GestureDetector(
            onTap: () async {

              /*showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Property'),
                  content: Text('Do you really want to Delete This Property?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.black,
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result_delete = await fetchData();
                        print(result_delete.first.id);
                        DeletePropertybyid('${result_delete.first.id}');
                        setState(() {
                          _isDeleting = true;
                        });
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_realestete(),), (route) => route.isFirst);
                      },
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ) ?? false;*/
              /*final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));

              if (result == true) {
                _refreshData();
              }*/
            },
            child: const Icon(
              PhosphorIcons.trash,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
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
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,int len){
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
                                                  height: 190,
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
                                            ],
                                          ),
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

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
                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Building Sell | Rent & Maintaince",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
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
                                                    width: 180,
                                                    child: Text(""+abc.data![len].Verify_price+"  |  "+abc.data![len].Rent+"  |  "+abc.data![len].maintence,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 14,

                                                          color: Colors.green,
                                                          fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Sqft | Balcony & Parking",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
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
                                                    width: 180,
                                                    child: Text(""+abc.data![len].sqft+"  |  "+abc.data![len].balcony+"  |  "+abc.data![len].Parking+" Parking" ,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
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
                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Building Information & facilitys",
                                                    style: TextStyle(
                                                        fontSize: 12,
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
                                                    width: 180,
                                                    child: Text(""+abc.data![len].Building_information,
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
                                                height: 20,
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



                                            ],
                                          ),


                                        ],
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Center(
                                        child: Text("Property owner",style: TextStyle(fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
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
                                                Text(""+abc.data![len].Ownername/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                            width: 20,
                                          ),

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
                                              width: 150,
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
                                                  Text(""+abc.data![len].Owner_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                        height: 10,
                                      ),

                                      Center(
                                        child: Text("CareTaker Info",style: TextStyle(fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
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
                                                Text(""+abc.data![len].Caretaker_name/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                            width: 20,
                                          ),

                                          GestureDetector(
                                            onTap: (){
                                              showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text('Call Property CareTaker'),
                                                  content: Text('Do you really want to Call CareTaker?'),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: Text('No'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        FlutterPhoneDirectCaller.callNumber('${abc.data![len].Caretaker_number}');
                                                      },
                                                      child: Text('Yes'),
                                                    ),
                                                  ],
                                                ),
                                              ) ?? false;
                                            },
                                            child: Container(
                                              width: 150,
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
                                                  Text(""+abc.data![len].Caretaker_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(PhosphorIcons.push_pin,size: 13,color: Colors.red,),
                                          SizedBox(width: 5,),
                                          Text("Property Name & Address",
                                            style: TextStyle(
                                                fontSize: 16,
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
                                            child: Text(""+abc.data![len].Address_,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Property Floor | Flat Number",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            width: 180,
                                            child: Text(""+abc.data![len].floor_+"  |  "+abc.data![len].flat_,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Building facilities",
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            child: Text(""+abc.data![len].facility,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Furnished | Furnished Details",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16,
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
                                            child: Text(""+abc.data![len].Furnished+"  |  "+abc.data![len].Details,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Kitchen | Bathroom",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            width: 320,
                                            child: Text(""+abc.data![len].kitchen+" Kitchen  |  "+abc.data![len].Baathroom+" Bathroom",
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Feild Worker Address",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            width: 320,
                                            child: Text(""+abc.data![len].Address_apnehisaabka,
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

                                      SizedBox(height: 20,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                                Text("Property Id = "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                      Center(
                                        child: Text("Feild Worker",style: TextStyle(fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),),
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: 1, color: Colors.yellow),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.yellow.withOpacity(0.5),
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
                                                Text(""+abc.data![len].Feild_name/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.5
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(
                                            width: 20,
                                          ),

                                          Container(
                                            width: 150,
                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(width: 1, color: Colors.yellow),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.yellow.withOpacity(0.5),
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
                                                Text(""+abc.data![len].Feild_number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.5
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Property Added Date",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            width: 320,
                                            child: Text(""+abc.data![len].date,
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
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                          SizedBox(width: 2,),
                                          Text("Property S.P | L.P",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                            width: 320,
                                            child: Text(""+abc.data![len].Sell_price+"  |  "+abc.data![len].Price  ,
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



          /*FutureBuilder<List<Catid>>(
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
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('id_Document', abc.data![len].id.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => ShowProperty(iidd: abc.data![len].id.toString()))
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          child:  Container(
                                            child: Image.asset(AppImages.propertysale,width: 120,fit: BoxFit.fill),
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
                                              Text(""+abc.data![len].type.toUpperCase(),
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
                                          child: Text(""+abc.data![len].PropertyAddress,
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
                                          child: Text(""+abc.data![len].Society,
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
                                          child: Text(""+abc.data![len].Place,
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
                                            Text(""+abc.data![len].City.toUpperCase(),
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
                              ),
                            )
                          ],
                        ),
                      );
                    });
              }


            }

        ),*/


        ),
      ),

    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
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
