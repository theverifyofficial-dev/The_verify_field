import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Custom_Widget/constant.dart';
import '../Custom_Widget/property_preview.dart';
class PropertyDetail {
  final String id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squareFit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWarkarName;
  final String liveUnlive;
  final String fieldWorkarNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String? subid;

  PropertyDetail({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squareFit,
    required this.maintenance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWarkarName,
    required this.liveUnlive,
    required this.fieldWorkarNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    this.subid,
  });

  factory PropertyDetail.fromJson(Map<String, dynamic> json) {
    return PropertyDetail(
      id: json["P_id"].toString(),
      propertyPhoto: json["property_photo"] ?? "",
      locations: json["locations"] ?? "",
      flatNumber: json["Flat_number"] ?? "",
      buyRent: json["Buy_Rent"] ?? "",
      residenceCommercial: json["Residence_Commercial"] ?? "",
      apartmentName: json["Apartment_name"] ?? "",
      apartmentAddress: json["Apartment_Address"] ?? "",
      typeOfProperty: json["Typeofproperty"] ?? "",
      bhk: json["Bhk"] ?? "",
      showPrice: json["show_Price"] ?? "",
      lastPrice: json["Last_Price"] ?? "",
      askingPrice: json["asking_price"] ?? "",
      floor: json["Floor_"] ?? "",
      totalFloor: json["Total_floor"] ?? "",
      balcony: json["Balcony"] ?? "",
      squareFit: json["squarefit"] ?? "",
      maintenance: json["maintance"] ?? "",
      parking: json["parking"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      fieldworkarAddress: json["fieldworkar_address"] ?? "",
      roadSize: json["Road_Size"] ?? "",
      metroDistance: json["metro_distance"] ?? "",
      highwayDistance: json["highway_distance"] ?? "",
      mainMarketDistance: json["main_market_distance"] ?? "",
      meter: json["meter"] ?? "",
      ownerName: json["owner_name"] ?? "",
      ownerNumber: json["owner_number"] ?? "",
      currentDates: json["current_dates"] ?? "",
      availableDate: json["available_date"] ?? "",
      kitchen: json["kitchen"] ?? "",
      bathroom: json["bathroom"] ?? "",
      lift: json["lift"] ?? "",
      facility: json["Facility"] ?? "",
      furnishedUnfurnished: json["furnished_unfurnished"] ?? "",
      fieldWarkarName: json["field_warkar_name"] ?? "",
      liveUnlive: json["live_unlive"] ?? "",
      fieldWorkarNumber: json["field_workar_number"] ?? "",
      registryAndGpa: json["registry_and_gpa"] ?? "",
      loan: json["loan"] ?? "",
      longitude: json["Longitude"] ?? "",
      latitude: json["Latitude"] ?? "",
      videoLink: json["video_link"] ?? "",
      fieldWorkerCurrentLocation: json["field_worker_current_location"] ?? "",
      careTakerName: json["care_taker_name"] ?? "",
      careTakerNumber: json["care_taker_number"] ?? "",
      subid: json["subid"],
    );
  }
}


class PropertyCompleteDetailPageNew extends StatefulWidget {
  final String propertyId;

  const PropertyCompleteDetailPageNew({super.key, required this.propertyId});

  @override
  State<PropertyCompleteDetailPageNew> createState() => _PropertyCompleteDetailPageNewState();
}

class _PropertyCompleteDetailPageNewState extends State<PropertyCompleteDetailPageNew> {
  late Future<PropertyDetail> propertyDetail;

  @override
  void initState() {
    super.initState();
    propertyDetail = fetchPropertyDetail(widget.propertyId);
  }
  Future<PropertyDetail> fetchPropertyDetail(String pId) async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/details_page_for_complete_payment.php?P_id=$pId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["status"] == "success" && decoded["data"] != null) {
        return PropertyDetail.fromJson(decoded["data"][0]);
      }
    }
    throw Exception("Failed to load property detail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
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
        ),        // centerTitle: true,
      ),
      body: FutureBuilder<PropertyDetail>(
        future: propertyDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No property data found"));
          }
          final property = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            child:
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PropertyPreview(
                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius
                                  .all(Radius
                                  .circular(
                                  10)),
                              child: Container(
                                height: 190,
                                width: 350,
                                child:
                                CachedNetworkImage(
                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/" +
                                      property.propertyPhoto,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context,
                                      url) =>
                                      Image
                                          .asset(
                                        AppImages
                                            .loading,
                                        fit: BoxFit
                                            .cover,
                                      ),
                                  errorWidget: (context,
                                      error,
                                      stack) =>
                                      Image.asset(
                                        AppImages
                                            .imageNotFound,
                                        fit: BoxFit
                                            .cover,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Container(
                              padding:
                              EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1,
                                    color: Colors.red),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0,0),
                                      blurStyle: BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "" + property.bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1, color: Colors.green),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle: BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text("" + property.typeOfProperty /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding:
                              EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1,
                                    color: Colors.red),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.red.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 0),
                                      blurStyle: BlurStyle.outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" + property.floor /*+abc.data![len].Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(
                              Iconsax.location_copy,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Show Price | Asking Price | Last Price",
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w600),
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
                              child: Text(
                                "" +
                                    property
                                        .showPrice +
                                    "  |  " +
                                    property
                                        .lastPrice +
                                    "  |  " +
                                    property
                                        .askingPrice,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .green,
                                    fontWeight:
                                    FontWeight
                                        .w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.home_1_copy,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Sqft | Balcony & Parking",
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w600),
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
                              child: Text(
                                "" +
                                    property
                                        .squareFit +
                                    "  |  " +
                                    property
                                        .balcony +
                                    "  |  " +
                                    property
                                        .parking +
                                    " Parking",
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors
                                        .black,
                                    fontWeight:
                                    FontWeight
                                        .w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              PhosphorIcons
                                  .address_book,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Flat Information & facility",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w600),
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
                              child: Text(
                                "" +
                                    property
                                        .facility,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .black,
                                    fontWeight:
                                    FontWeight
                                        .w400),
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
                              padding:
                              EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors
                                        .blue),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .blue
                                          .withOpacity(
                                          0.5),
                                      blurRadius:
                                      10,
                                      offset:
                                      Offset(
                                          0,
                                          0),
                                      blurStyle:
                                      BlurStyle
                                          .outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        property
                                            .locations /*+property.Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize:
                                        13,
                                        color: Colors
                                            .black,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        letterSpacing:
                                        0.5),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding:
                              EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 0,
                                  bottom: 0),
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    5),
                                border: Border.all(
                                    width: 1,
                                    color: Colors
                                        .blue),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors
                                          .blue
                                          .withOpacity(
                                          0.5),
                                      blurRadius:
                                      10,
                                      offset:
                                      Offset(
                                          0,
                                          0),
                                      blurStyle:
                                      BlurStyle
                                          .outer),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Icon(Iconsax.sort_copy,size: 15,),
                                  //w SizedBox(width: 10,),
                                  Text(
                                    "" +
                                        property
                                            .buyRent /*+property.Building_Name.toUpperCase()*/,
                                    style: TextStyle(
                                        fontSize:
                                        13,
                                        color: Colors
                                            .black,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        letterSpacing:
                                        0.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Property owner",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          border: Border.all(
                              width: 1,
                              color:
                              Colors.purple),
                          boxShadow: [
                            BoxShadow(
                                color: Colors
                                    .purple
                                    .withOpacity(
                                    0.5),
                                blurRadius: 10,
                                offset:
                                Offset(0, 0),
                                blurStyle:
                                BlurStyle
                                    .outer),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            // Icon(Iconsax.sort_copy,size: 15,),
                            //SizedBox(width: 10,),
                            Text(
                              "" +
                                  property
                                      .ownerName,
                              maxLines: 2,
                              /*+property.Building_Name.toUpperCase()*/
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  letterSpacing:
                                  0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<bool>(
                            context: context,
                            builder:
                                (context) =>
                                AlertDialog(
                                  title: Text(
                                      'Call Property Owner'),
                                  content: Text(
                                      'Do you really want to Call Owner?'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context)
                                              .pop(false),
                                      child: Text(
                                          'No'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () async {
                                        FlutterPhoneDirectCaller
                                            .callNumber(
                                            '${property.ownerNumber}');
                                      },
                                      child: Text(
                                          'Yes'),
                                    ),
                                  ],
                                ),
                          ) ??
                              false;
                        },
                        child: Container(
                          width: 150,
                          padding:
                          EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 0,
                              bottom: 0),
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .purple),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors
                                      .purple
                                      .withOpacity(
                                      0.5),
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0),
                                  blurStyle:
                                  BlurStyle
                                      .outer),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              // Icon(Iconsax.sort_copy,size: 15,),
                              //SizedBox(width: 10,),
                              Text(
                                "" +
                                    property
                                        .ownerNumber /*+property.Building_Name.toUpperCase()*/,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .black,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    letterSpacing:
                                    0.5),
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
                    child: Text(
                      "CareTaker Info",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          border: Border.all(
                              width: 1,
                              color:
                              Colors.purple),
                          boxShadow: [
                            BoxShadow(
                                color: Colors
                                    .purple
                                    .withOpacity(
                                    0.5),
                                blurRadius: 10,
                                offset:
                                Offset(0, 0),
                                blurStyle:
                                BlurStyle
                                    .outer),
                          ],
                        ),
                        child: Text(
                          "" +
                              property
                                  .careTakerName /*+property.Building_Name.toUpperCase()*/,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight.w500,
                              letterSpacing: 0.5),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<bool>(
                            context: context,
                            builder:
                                (context) =>
                                AlertDialog(
                                  title: Text(
                                      'Call Property CareTaker'),
                                  content: Text(
                                      'Do you really want to Call CareTaker?'),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context)
                                              .pop(false),
                                      child: Text(
                                          'No'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () async {
                                        FlutterPhoneDirectCaller
                                            .callNumber(
                                            '${property.careTakerNumber}');
                                      },
                                      child: Text(
                                          'Yes'),
                                    ),
                                  ],
                                ),
                          ) ??
                              false;
                        },
                        child: Container(
                          width: 150,
                          padding:
                          EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 0,
                              bottom: 0),
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors
                                    .purple),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors
                                      .purple
                                      .withOpacity(
                                      0.5),
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0),
                                  blurStyle:
                                  BlurStyle
                                      .outer),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              // Icon(Iconsax.sort_copy,size: 15,),
                              //SizedBox(width: 10,),
                              Text(
                                "" +
                                    property
                                        .careTakerNumber /*+property.Building_Name.toUpperCase()*/,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .black,
                                    fontWeight:
                                    FontWeight
                                        .w500,
                                    letterSpacing:
                                    0.5),
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
                      Icon(
                        PhosphorIcons.push_pin,
                        size: 13,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Property Name & Address",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .apartmentAddress,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.home_1_copy,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Property Floor | Flat Number",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .floor +
                              "  |  " +
                              property
                                  .flatNumber,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.push_pin,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Flat facilities",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .facility,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.home_1_copy,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Furnished | Furnished Items",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .furnishedUnfurnished +
                              "  |  " +
                              property
                                  .apartmentName,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.home_1_copy,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Kitchen | Bathroom",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .kitchen +
                              " Kitchen  |  " +
                              property
                                  .bathroom +
                              " Bathroom",
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.home_1_copy,
                        size: 12,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Feild Worker Address",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w600),
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
                        child: Text(
                          "" +
                              property
                                  .fieldworkarAddress,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight:
                              FontWeight
                                  .w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          border: Border.all(
                              width: 1,
                              color: Colors.red),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red
                                    .withOpacity(
                                    0.5),
                                blurRadius: 10,
                                offset:
                                Offset(0, 0),
                                blurStyle:
                                BlurStyle
                                    .outer),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon(Iconsax.sort_copy,size: 15,),
                            //w SizedBox(width: 10,),
                            Text(
                              "Property Id = " +
                                  property
                                      .id
                                      .toString() /*+property.Building_Name.toUpperCase()*/,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w500,
                                  letterSpacing:
                                  0.5),
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
                  Center(
                    child: Text(
                      "Feild Worker",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          border: Border.all(
                              width: 1,
                              color:
                              Colors.yellow),
                          boxShadow: [
                            BoxShadow(
                                color: Colors
                                    .yellow
                                    .withOpacity(
                                    0.5),
                                blurRadius: 10,
                                offset:
                                Offset(0, 0),
                                blurStyle:
                                BlurStyle
                                    .outer),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            // Icon(Iconsax.sort_copy,size: 15,),
                            //SizedBox(width: 10,),
                            Text(
                              "" +
                                  property
                                      .fieldWarkarName /*+property.Building_Name.toUpperCase()*/,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w400,
                                  letterSpacing:
                                  0.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 150,
                        padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 0,
                            bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(5),
                          border: Border.all(
                              width: 1,
                              color:
                              Colors.yellow),
                          boxShadow: [
                            BoxShadow(
                                color: Colors
                                    .yellow
                                    .withOpacity(
                                    0.5),
                                blurRadius: 10,
                                offset:
                                Offset(0, 0),
                                blurStyle:
                                BlurStyle
                                    .outer),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            // Icon(Iconsax.sort_copy,size: 15,),
                            //SizedBox(width: 10,),
                            Text(
                              "" +
                                  property
                                      .fieldWorkarNumber /*+property.Building_Name.toUpperCase()*/,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors
                                      .black,
                                  fontWeight:
                                  FontWeight
                                      .w400,
                                  letterSpacing:
                                  0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Residence Commercial : " +
                            property
                                .residenceCommercial,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Maintance : " +
                            property.maintenance,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Road Size : " +
                            property.roadSize,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Age Of Property : " +
                            property
                                .ageOfProperty,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Metro Name : " +
                            property
                                .highwayDistance,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Metro Distance : " +
                            property
                                .metroDistance,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Main Market Distance : " +
                            property
                                .mainMarketDistance,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Meter : " +
                            property.meter,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Lift : " +
                            property.lift,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Registry And Gpa : " +
                            property
                                .registryAndGpa ??
                            "",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Loan : " +
                            property.loan ??
                            "",
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Flat Available Date : " +
                            property
                                .availableDate,
                        overflow:
                        TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.w500),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Iconsax.home_1_copy,
                            size: 12,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Property Added Date",
                            overflow:
                            TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight:
                                FontWeight.w600),
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
                            child: Text(
                              "" +
                                  property.currentDates,
                              overflow: TextOverflow
                                  .ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight
                                      .w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color)),
      child: Text(
        "$title: $value",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
