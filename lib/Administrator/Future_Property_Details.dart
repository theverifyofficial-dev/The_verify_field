import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../model/docpropertySlider.dart';
import '../model/futureProperty_Slideer.dart';
import '../model/realestateModel.dart';
import 'Update_Future_Property.dart';

class FutureProperty2 {
  final int id;
  final String images;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String selectBhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyNameAddress;
  final String buildingInformationFacilities;
  final String propertyAddressForFieldworker;
  final String ownerVehicleNumber;
  final String yourAddress;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String currentDate;
  final String longitude;
  final String latitude;
  final String roadSize;
  final String metroDistance;
  final String metroName;
  final String mainMarketDistance;
  final String ageOfProperty;
  final String lift;
  final String parking;
  final String totalFloor;
  final String apartmentName; // optional, API may not have
  final String facility;
  final String currentLocation; // optional, API may not have
  final String residenceCommercial;

  FutureProperty2({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldworkerName,
    required this.fieldworkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.apartmentName,
    required this.facility,
    required this.currentLocation,
    required this.residenceCommercial,
  });

  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: json['id'],
      images: json['images'] ?? '',
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      typeOfProperty: json['typeofproperty'] ?? '',
      selectBhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      propertyNameAddress: json['propertyname_address'] ?? '',
      buildingInformationFacilities: json['building_information_facilitys'] ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'] ?? '',
      ownerVehicleNumber: json['owner_vehical_number'] ?? '',
      yourAddress: json['your_address'] ?? '',
      fieldworkerName: json['fieldworkarname'] ?? '',
      fieldworkerNumber: json['fieldworkarnumber'] ?? '',
      currentDate: json['current_date_'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      metroName: json['metro_name'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      lift: json['lift'] ?? '',
      parking: json['parking'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      apartmentName: json['apartment_name'] ?? '', // default empty
      facility: json['facility'] ?? '',
      currentLocation: json['your_address'] ?? '', // use your_address as fallback
      residenceCommercial: json['Residence_commercial'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'ownername': ownerName,
      'ownernumber': ownerNumber,
      'caretakername': caretakerName,
      'caretakernumber': caretakerNumber,
      'place': place,
      'buy_rent': buyRent,
      'typeofproperty': typeOfProperty,
      'select_bhk': selectBhk,
      'floor_number': floorNumber,
      'sqyare_feet': squareFeet,
      'propertyname_address': propertyNameAddress,
      'building_information_facilitys': buildingInformationFacilities,
      'property_address_for_fieldworkar': propertyAddressForFieldworker,
      'owner_vehical_number': ownerVehicleNumber,
      'your_address': yourAddress,
      'fieldworkarname': fieldworkerName,
      'fieldworkarnumber': fieldworkerNumber,
      'current_date_': currentDate,
      'longitude': longitude,
      'latitude': latitude,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'metro_name': metroName,
      'main_market_distance': mainMarketDistance,
      'age_of_property': ageOfProperty,
      'lift': lift,
      'parking': parking,
      'total_floor': totalFloor,
      'apartment_name': apartmentName,
      'facility': facility,
      'field_worker_current_location': currentLocation,
      'Residence_commercial': residenceCommercial,
    };
  }
}

class Administater_Future_Property_details extends StatefulWidget {
  String idd;
  Administater_Future_Property_details({super.key, required this.idd});

  @override
  State<Administater_Future_Property_details> createState() => _Administater_Future_Property_detailsState();
}

class _Administater_Future_Property_detailsState extends State<Administater_Future_Property_details> {



  Future<List<FutureProperty2>> fetchData(id_num) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=$id_num");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => FutureProperty2.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_addimages_by_subid_?subid=${widget.idd}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool _isDeleting = false;



  // final result = await fetchData();

  List<String> name = [];

  // late final int iid;

  int _id = 0;

  @override
  void initState() {
    super.initState();

  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

  Future<void> _handleMenuItemClick(String value) async {
    // Handle the menu item click
    print("You clicked: $value");
    if(value.toString() == 'Edit Property'){

      fetchData(widget.idd);
      final Result = await fetchData(widget.idd);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Update_FutureProperty(id: '${Result.first.id}',ownername: '${Result.first.ownerName}',ownernumber: '${Result.first.ownerNumber}', caretakername: '${Result.first.caretakerName}',
                caretakernumber: '${Result.first.caretakerNumber}', place: '${Result.first.place}', buy_rent: '${Result.first.buyRent}', typeofproperty: '${Result.first.typeOfProperty}', select_bhk: '${Result.first.selectBhk}',
                floor_number: '${Result.first.floorNumber}', sqyare_feet: '${Result.first.squareFeet}', propertyname_address: '${Result.first.propertyNameAddress}', building_information_facilitys: '${Result.first.buildingInformationFacilities}',
                property_address_for_fieldworkar: '${Result.first.propertyAddressForFieldworker}', owner_vehical_number: '${Result.first.ownerVehicleNumber}', your_address: '${Result.first.yourAddress}',)));

    }
    if(value.toString() == 'Add Property Images'){

      /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutyureProperty_FileUploadPage(idd: '${widget.idd}',)));*/


      /*Fluttertoast.showToast(
          msg: 'Add Property Images',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );*/
    }
    if(value.toString() == 'Delete Added Images'){
      Fluttertoast.showToast(
          msg: 'Delete Added Images',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
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
        // actions: [
        //   PopupMenuButton<String>(
        //     onSelected: _handleMenuItemClick,
        //     itemBuilder: (BuildContext context) {
        //       return {'Edit Property',  'Add Property Images', 'Delete This Property'}.map((String choice) {
        //         return PopupMenuItem<String>(
        //           value: choice,
        //           child: Text(choice),
        //         );
        //       }).toList();
        //     },
        //   ),
        // ],
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // FutureBuilder<List<DocumentMainModel_F>>(
              //   future: fetchCarouselData(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text('Error: ${snapshot.error}'));
              //     } else if (!snapshot.hasData) {
              //       return Center(child: Text('No data available.'));
              //     } else {
              //       return CarouselSlider(
              //         options: CarouselOptions(
              //           height: 180.0,
              //           enlargeCenterPage: true,
              //           autoPlay: true,
              //           autoPlayInterval: const Duration(seconds: 2),
              //         ),
              //         items: snapshot.data!.map((item) {
              //           return Builder(
              //             builder: (BuildContext context) {
              //               return  Container(
              //                 margin: const EdgeInsets.only(right: 10),
              //                 width: 320,
              //                 child: ClipRRect(
              //                   borderRadius:
              //                   const BorderRadius.all(Radius.circular(15)),
              //                   child: CachedNetworkImage(
              //                     imageUrl:
              //                     "https://verifyserve.social/PHP_Files/future_property_slider_images/${item.dimage}",
              //                     fit: BoxFit.cover,
              //                     placeholder: (context, url) => Image.asset(
              //                       AppImages.loading,
              //                       fit: BoxFit.cover,
              //                     ),
              //                     errorWidget: (context, error, stack) =>
              //                         Image.asset(
              //                           AppImages.imageNotFound,
              //                           fit: BoxFit.cover,
              //                         ),
              //                   ),
              //                 ),
              //               );
              //             },
              //           );
              //         }).toList(),
              //       );
              //     }
              //   },
              // ),

              FutureBuilder<List<FutureProperty2>>(
                  future: fetchData(widget.idd),
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

                                  ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      height: 300,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/"+(abc.data![len].images??""),
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

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 5),
                                    child:
                                    Card(
                                      color: Colors.grey.shade100,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Wrap(
                                              spacing: 8, // horizontal gap
                                              runSpacing: 6, // vertical gap (if wraps to next line)
                                              children: [
                                                _buildInfoChip( text: abc.data![len].place, borderColor: Colors.green),
                                                _buildInfoChip( text: abc.data![len].residenceCommercial, borderColor: Colors.green),
                                                _buildInfoChip( text: abc.data![len].buyRent, borderColor: Colors.green),
                                                Text(
                                                  "Id : ${abc.data![len].id}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
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
                                                Text("Owner Name | Owner Number | Owner Vehicle Number",
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
                                            Wrap(
                                              spacing: 8, // horizontal gap
                                              runSpacing: 6, // vertical gap (when items wrap)
                                              children: [
                                                _buildInfoChip( text: abc.data![len].ownerName, borderColor: Colors.red),
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Contact ${abc.data![len].ownerNumber}"),
                                                        content: Text('Do you really want to Contact? ${abc.data![len].ownerNumber}'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () async {
                                                                  if (Platform.isAndroid) {
                                                                    String url = 'whatsapp://send?phone=91${abc.data![len].ownerNumber}&text=Hello';
                                                                    await launchUrl(Uri.parse(url));
                                                                  } else {
                                                                    String url = 'https://wa.me/${abc.data![len].ownerNumber}';
                                                                    await launchUrl(Uri.parse(url));
                                                                  }
                                                                },
                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800),
                                                                child: Image.asset(AppImages.whatsaap, height: 40, width: 40),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  FlutterPhoneDirectCaller.callNumber('${abc.data![len].ownerNumber}');
                                                                },
                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade800),
                                                                child: Image.asset(AppImages.call, height: 40, width: 40),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: _buildInfoChip( text: abc.data![len].ownerNumber, borderColor: Colors.red),
                                                ),
                                                _buildInfoChip( text: abc.data![len].ownerVehicleNumber, borderColor: Colors.red),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text("Caretaker Name | Caretaker Number",
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
                                                _buildInfoChip(
                                                  text: abc.data![len].caretakerName,
                                                  borderColor: Colors.purple,
                                                ),

                                                SizedBox(
                                                  width: 10,
                                                ),

                                                GestureDetector(
                                                  onTap: (){

                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Call Property Caretaker'),
                                                        content: Text('Do you really want to Call Caretaker?'),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              FlutterPhoneDirectCaller.callNumber('${abc.data![len].caretakerNumber}');
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ?? false;
                                                  },
                                                  child: _buildInfoChip(
                                                    text: abc.data![len].caretakerNumber,
                                                    borderColor: Colors.purple,
                                                  ),
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
                                                Text("Property Address For Feild Workers",
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
                                                  child: Text(""+abc.data![len].propertyAddressForFieldworker,
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
                                                  child: Text(""+abc.data![len].propertyNameAddress,
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
                                                SizedBox(
                                                  width: 300,
                                                  child: Text("Total Floor : "+abc.data![len].totalFloor,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
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
                                            Column(
                                              children: [
                                                //                   Container(
                                                //                     padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                //                     decoration: BoxDecoration(
                                                //                       borderRadius: BorderRadius.circular(5),
                                                //                       border: Border.all(width: 1, color: Colors.blue),
                                                //                       boxShadow: [
                                                //                         BoxShadow(
                                                //                             color: Colors.blue.withOpacity(0.5),
                                                //                             blurRadius: 10,
                                                //                             offset: Offset(0, 0),
                                                //                             blurStyle: BlurStyle.outer
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                     child: Row(
                                                //                       children: [
                                                //                         // Icon(Iconsax.sort_copy,size: 15,),
                                                //                         //SizedBox(width: 10,),
                                                //                         Expanded(
                                                //                           child: Text(""+abc.data![len].facility/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                //                             style: TextStyle(
                                                //                                 fontSize: 13,
                                                //                                 color: Colors.black,
                                                //                                 fontWeight: FontWeight.w500,
                                                //                                 letterSpacing: 0.5
                                                //                             ),
                                                //                             overflow: TextOverflow.ellipsis,
                                                //                             maxLines: 2,
                                                //                           ),
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                   ),
                                                //
                                                //                   SizedBox(
                                                //                     height: 10,
                                                //                   ),
                                                //
                                                //                   Container(
                                                //                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                                //                   decoration: BoxDecoration(
                                                //                   borderRadius: BorderRadius.circular(5),
                                                //                   border: Border.all(width: 1, color: Colors.blue),
                                                //                   boxShadow: [
                                                //                   BoxShadow(
                                                //                   color: Colors.blue.withOpacity(0.5),
                                                //                   blurRadius: 10,
                                                //                   offset: const Offset(0, 0),
                                                //                   blurStyle: BlurStyle.outer,
                                                //                   ),
                                                //                   ],
                                                //                   ),
                                                //                   child: Text(
                                                //                   abc.data![len].propertyNameAddress,
                                                // style: const TextStyle(
                                                // fontSize: 13,
                                                // color: Colors.black,
                                                // fontWeight: FontWeight.w500,
                                                // letterSpacing: 0.5,
                                                // ),
                                                // ),
                                                // ),
                                                //                   Container(
                                                //                     padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                //                     decoration: BoxDecoration(
                                                //                       borderRadius: BorderRadius.circular(5),
                                                //                       border: Border.all(width: 1, color: Colors.blue),
                                                //                       boxShadow: [
                                                //                         BoxShadow(
                                                //                             color: Colors.blue.withOpacity(0.5),
                                                //                             blurRadius: 10,
                                                //                             offset: Offset(0, 0),
                                                //                             blurStyle: BlurStyle.outer
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                     child: Row(
                                                //                       children: [
                                                //                         // Icon(Iconsax.sort_copy,size: 15,),
                                                //                         //SizedBox(width: 10,),
                                                //                         Expanded(
                                                //                           child: Text(""+abc.data![len].facility/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                //                             style: TextStyle(
                                                //                                 fontSize: 13,
                                                //                                 color: Colors.black,
                                                //                                 fontWeight: FontWeight.w500,
                                                //                                 letterSpacing: 0.5
                                                //                             ),
                                                //                             overflow: TextOverflow.ellipsis,
                                                //                             maxLines: 2,
                                                //                           ),
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                   ),
                                                //
                                                //                   SizedBox(
                                                //                     height: 10,
                                                //                   ),
                                                //
                                                //                   Container(
                                                //                   padding: const EdgeInsets.symmetric(horizontal: 10),
                                                //                   decoration: BoxDecoration(
                                                //                   borderRadius: BorderRadius.circular(5),
                                                //                   border: Border.all(width: 1, color: Colors.blue),
                                                //                   boxShadow: [
                                                //                   BoxShadow(
                                                //                   color: Colors.blue.withOpacity(0.5),
                                                //                   blurRadius: 10,
                                                //                   offset: const Offset(0, 0),
                                                //                   blurStyle: BlurStyle.outer,
                                                //                   ),
                                                //                   ],
                                                //                   ),
                                                //                   child: Text(
                                                //                   abc.data![len].propertyNameAddress,
                                                // style: const TextStyle(
                                                // fontSize: 13,
                                                // color: Colors.black,
                                                // fontWeight: FontWeight.w500,
                                                // letterSpacing: 0.5,
                                                // ),
                                                // ),
                                                // ),

                                              ],
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Building Add Date : "+abc.data![len].currentDate/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Road Size : "+abc.data![len].roadSize/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Metro Name : "+abc.data![len].metroName/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Metro Distance : "+abc.data![len].metroDistance/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Main Market Distance: "+abc.data![len].mainMarketDistance/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("Age of Property: "+abc.data![len].ageOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),
                                            SizedBox(height: 6,),
                                            Text("lift : "+abc.data![len].lift/*+abc.data![len].Building_Name.toUpperCase()*/,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5
                                              ),
                                            ),


                                            SizedBox(height: 6,),
                                            Text("Parking "+abc.data![len].parking/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                  )



                                ],
                              ),
                            );
                          });
                    }


                  }

              ),

            ],
          ),






        ),
      ),
    );
  }
  Widget _buildInfoChip({required String text, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

}
