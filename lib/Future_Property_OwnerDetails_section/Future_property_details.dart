import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Owner_Call/All_contact.dart';
import 'dart:io';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/futureProperty_Slideer.dart';
import 'Add_FutureProperty_Images.dart';
import 'Duplicate_Property.dart';
import 'Edit_futureproperty/Edit_Building.dart';
import 'Update_future_building.dart';
import 'add_flat_form.dart';
import 'New_Update/under_flats_infutureproperty.dart';

import 'package:intl/intl.dart';

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
  final String residenceCommercial;
  final String facility;
  final String localitiesList;

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
    required this.residenceCommercial,
    required this.facility,
    required this.localitiesList,
  });

  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: int.tryParse(json["id"].toString()) ?? 0,
      images: json["images"] ?? "",
      ownerName: json["ownername"] ?? "",
      ownerNumber: json["ownernumber"] ?? "",
      caretakerName: json["caretakername"] ?? "",
      caretakerNumber: json["caretakernumber"] ?? "",
      place: json["place"] ?? "",
      buyRent: json["buy_rent"] ?? "",
      typeOfProperty: json["typeofproperty"] ?? "",
      selectBhk: json["select_bhk"] ?? "",
      floorNumber: json["floor_number"] ?? "",
      squareFeet: json["sqyare_feet"] ?? "",
      propertyNameAddress: json["propertyname_address"] ?? "",
      buildingInformationFacilities: json["building_information_facilitys"] ?? "",
      propertyAddressForFieldworker: json["property_address_for_fieldworkar"] ?? "",
      ownerVehicleNumber: json["owner_vehical_number"] ?? "",
      yourAddress: json["your_address"] ?? "",
      fieldworkerName: json["fieldworkarname"] ?? "",
      fieldworkerNumber: json["fieldworkarnumber"] ?? "",
      currentDate: json["current_date_"] ?? "",
      longitude: json["longitude"] ?? "",
      latitude: json["latitude"] ?? "",
      roadSize: json["Road_Size"] ?? "",
      metroDistance: json["metro_distance"] ?? "",
      metroName: json["metro_name"] ?? "",
      mainMarketDistance: json["main_market_distance"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      lift: json["lift"] ?? "",
      parking: json["parking"] ?? "",
      totalFloor: json["total_floor"] ?? "",
      residenceCommercial: json["Residence_commercial"] ?? "",
      facility: json["facility"] ?? "",
      localitiesList: json["locality_list"] ?? "",
    );
  }
}


class Ground {
  final int id;
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
  final String squarefit;
  final String maintance;
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
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Ground({
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
    required this.squarefit,
    required this.maintance,
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
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Ground.fromJson(Map<String, dynamic> json) {
    return Ground(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid'] ?? '',
    );
  }
}

class Future_Property_details extends StatefulWidget {
  String idd;
  Future_Property_details({super.key, required this.idd});

  @override
  State<Future_Property_details> createState() => _Future_Property_detailsState();
}

class _Future_Property_detailsState extends State<Future_Property_details> {

  Future<List<Ground>> fetchData_Ground() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=G%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_first() async {
      var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=1%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_second() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/second_floor_base_show_mainrealestae?Floor_=2%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_third() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=3%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_four() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=4%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_five() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=5%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_six() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=6%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Ground>> fetchData_seven() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=7%20Floor&subid=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Ground.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FutureProperty2>> fetchData() async {
    var url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.idd}");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded["data"] == null) return [];

      final List rawList = decoded["data"];

      return rawList
          .map((e) => FutureProperty2.fromJson(e))
          .toList();
    } else {
      throw Exception("Unexpected error occurred!");
    }
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_multiple_images?subid=${widget.idd}'));
    print(widget.idd);
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

  List<String> name = [];
  late Future<Map<String, dynamic>> _allDataFuture;

  @override
  void initState() {
    super.initState();
    _allDataFuture = _fetchAllData(); // all data loaded together
  }

  Future<Map<String, dynamic>> _fetchAllData() async {
    try {
      // Run all API calls in parallel
      final results = await Future.wait([
        fetchData_Ground(),
        fetchData_first(),
        fetchData_second(),
        fetchData_third(),
        fetchData_four(),
        fetchData_five(),
        fetchData_six(),
        fetchData_seven(),
        fetchData(),
        fetchCarouselData(),
      ]);

      return {
        'groundList': results[0],
        'firstList': results[1],
        'secondList': results[2],
        'thirdList': results[3],
        'fourthList': results[4],
        'fifthList': results[5],
        'sixList': results[6],
        'sevenList': results[7],
        'catidList': results[8],
        'imageList': results[9],
      };
    } catch (e) {
      print("Error fetching all data: $e");
      throw Exception('Failed to load all data');
    }
  }

  List<Ground> groundList = [];
  List<Ground> firstList = [];
  List<Ground> secondList = [];
  List<Ground> thirdList = [];
  List<Ground> fourthList = [];
  List<Ground> fifthList = [];
  List<Ground> sixList = [];
  List<Ground> sevenList = [];

  List<FutureProperty2> catidList = [];
  List<DocumentMainModel_F> imageList = [];
  Future<void> _refreshAllData() async {
    try {
      final ground = await fetchData_Ground();
      final first = await fetchData_first();
      final second = await fetchData_second();
      final third = await fetchData_third();
      final fourth = await fetchData_four();
      final fifth = await fetchData_five();
      final sixth = await fetchData_six();
      final seven = await fetchData_seven();
      final catids = await fetchData();
      final images = await fetchCarouselData();

      setState(() {
        groundList = ground;
        firstList = first;
        secondList = second;
        thirdList = third;
        fourthList = fourth;
        fifthList = fifth;
        sixList = sixth;
        sevenList = seven;
        catidList = catids;
        imageList = images;
      });
    } catch (e) {
      print('Refresh Error: $e');
      // Optionally show a toast or Snackbar
    }
  }
  String data = 'Initial Data';

  Future<void> _handleMenuItemClick(String value) async {
    print("You clicked: $value");
    if (value == 'Edit Building') {
      final result = await fetchData(); // Only call once
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateRealEstateProperty(
            propertyId: int.parse(widget.idd),
          ),
        ),
      );
    }

    if (value.toString() == 'Add Building Images') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FuturePropertyFileUploadPage(
                idd: widget.idd, // No need to parse
              ),
        ),
      );
    }
    // if (value.toString() == 'Duplicate Property') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => DuplicateProperty(
    //         propertyId: int.tryParse(widget.idd) ?? 0,
    //         // sId: int.tryParse() ?? 0,
    //       ),
    //     ),
    //   );
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,


      body: RefreshIndicator(
        onRefresh: _refreshAllData,

        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // 👈 ensures pull-to-refresh works

          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              centerTitle: true,
              title: Image.asset(AppImages.verify, height: 75),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    SizedBox(width: 3),
                    Icon(
                      PhosphorIcons.caret_left_bold,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: _handleMenuItemClick,
                  itemBuilder: (BuildContext context) {
                    return {
                      'Edit Building',
                      'Add Building Images',
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white, // ✅ makes the icon white
                  ),
                ),
              ],
            ),


            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_Ground(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Ground Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            width: 100,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_first(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
                      } else {
                        final data = abc.data!;
                        return Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'First Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

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
                                                                SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_second(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Second Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                // ElevatedButton(
                                //   onPressed: () {
                                //     print('Subid is: ${abc.data![0].subid}');
                                //   },
                                //   child: Text('Subid: ${abc.data![0].subid}'),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_third(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Third Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            width: 6,
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_four(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Forth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_five(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Fifth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            width: 6,
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_six(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    ' Sixth Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
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
                                                                //SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            width: 6,
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

                  return FutureBuilder<List<Ground>>(
                    future: fetchData_seven(),
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (abc.hasError) {
                        return Center(child: Text('Error: ${abc.error}'));
                      } else if (!abc.hasData || abc.data!.isEmpty) {
                        return Center(child: Text(''));
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
                                    'Seventh  Floor',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250, // 👈 this controls height

                              child: ListView.builder(

                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context,int len) {
                                  return Container(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
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
                                                                Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("Flat no."+abc.data![len].flatNumber/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                                Text("₹ "+abc.data![len].showPrice/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius.all(Radius.circular(10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 220,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+abc.data![len].propertyPhoto,
                                                                    fit: BoxFit.cover,
                                                                    placeholder: (context, url) => Image.asset(
                                                                      AppImages.loading,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    errorWidget: (context, error, stack) =>
                                                                        Image.asset(
                                                                          AppImages.imageNotFound,
                                                                          fit: BoxFit.fill,
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

                                                      SizedBox(height: 6,),

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
                                                                //SizedBox(width: 10,),
                                                                SizedBox(width: 10,),
                                                                Text(""+abc.data![len].typeOfProperty/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.cyan),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.cyan.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].locations/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                              border: Border.all(width: 1, color: Colors.deepPurple),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.deepPurple.withOpacity(0.5),
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
                                                                Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      SizedBox(height: 10,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                        children: [
                                                          Text(
                                                            " ${(() {
                                                              final s = abc.data![len].currentDate?.toString() ?? '';
                                                              if (s.isEmpty) return '-';
                                                              try {

                                                                final dt = DateFormat('yyyy-MM-dd').parse(s);
                                                                return DateFormat('dd MMM yyyy').format(dt);
                                                              } catch (_) {
                                                                try {
                                                                  final dt2 = DateTime.parse(s);
                                                                  return DateFormat('dd MMM yyyy').format(dt2);
                                                                } catch (_) {
                                                                  return s;
                                                                }
                                                              }
                                                            })()}",
                                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: "Poppins",
                                                                color: Colors.black

                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 100,
                                                          ),
                                                          Text("ID : "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                  color: Colors.black
                                                              )),
                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
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

            //building details

            SliverList(

              delegate: SliverChildBuilderDelegate(
                    (context, index) {

                  return FutureBuilder<List<FutureProperty2>>(
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
                          final List<String> localityChips =
                          abc.data![0].localitiesList.split(',').map((e) => e.trim()).toList();
                          print('Locality list: $localityChips');
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllContact(
                                          buildingId: abc.data![0].id.toString(),       // building ID (from API)
                                          ownerName: abc.data![0].ownerName,            // owner name
                                          ownerNumber: abc.data![0].ownerNumber,        // owner number
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    backgroundColor: Colors.purple.shade300,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  icon: const Icon(Icons.call, size: 22),
                                  label: const Text(
                                    "Calling Section",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),

                                ),
                                const SizedBox(height: 20),
                                Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white12
                                      : Colors.grey.shade200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        /// Property Type Tags
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 4,
                                          children: [
                                            _buildInfoChip(
                                              text: abc.data![0].place,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.green.withOpacity(0.2)
                                                  : Colors.green.shade50,
                                              textColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Colors.green.shade800,
                                              borderColor: Colors.green,
                                            ),
                                            _buildInfoChip(
                                              text: abc.data![0].residenceCommercial,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.blue.withOpacity(0.2)
                                                  : Colors.blue.shade50,
                                              textColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.blue.shade200
                                                  : Colors.blue.shade800,
                                              borderColor: Colors.blue,
                                            ),
                                            _buildInfoChip(
                                              text: abc.data![0].buyRent,
                                              backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.orange.withOpacity(0.2)
                                                  : Colors.orange.shade50,
                                              textColor: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.orange.shade200
                                                  : Colors.orange.shade800,
                                              borderColor: Colors.orange,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 10),
                                        Divider(height: 1, color: Theme.of(context).dividerColor),
                                        const SizedBox(height: 10),

                                        _buildCompactSection(
                                          icon: Icons.person_outline,
                                          title: "Owner Info",
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          children: [
                                            _buildCompactChip(
                                              icon: Icons.person,
                                              text: abc.data![0].ownerName,
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Colors.grey.shade200,
                                              borderColor: Colors.deepPurpleAccent,
                                              shadowColor: Colors.deepPurpleAccent,
                                            ),
                                            GestureDetector(
                                              onTap: () => _showContactDialog(context, abc.data![0].ownerNumber),
                                              child: _buildCompactChip(
                                                icon: Icons.phone,
                                                text: abc.data![0].ownerNumber,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.white
                                                    : Colors.grey.shade200,
                                                borderColor: Colors.deepPurpleAccent,
                                                shadowColor: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        /// Vehicle number chip
                                        Center(
                                          child: _buildCompactChip(
                                            icon: Icons.directions_car,
                                            text: abc.data![0].ownerVehicleNumber,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.grey.shade200,
                                            borderColor: Colors.cyan,
                                            shadowColor: Colors.cyan,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        /// Caretaker Section
                                        _buildCompactSection(
                                          icon: Icons.support_agent,
                                          title: "Caretaker",
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          children: [
                                            Wrap(
                                              spacing: 12,
                                              runSpacing: 8,
                                              children: [
                                                _buildCompactChip(
                                                  icon: Icons.person,
                                                  text: abc.data![0].caretakerName,
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.white
                                                      : Colors.grey.shade200,
                                                  borderColor: Colors.blue,
                                                  shadowColor: Colors.red,
                                                ),
                                                GestureDetector(
                                                  onTap: () => _showCallDialog(
                                                    context,
                                                    abc.data![0].caretakerNumber,
                                                    "Caretaker",
                                                  ),
                                                  child: _buildCompactChip(
                                                    icon: Icons.phone,
                                                    text: abc.data![0].caretakerNumber,
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.white
                                                        : Colors.grey.shade200,
                                                    borderColor: Colors.blue,
                                                    shadowColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        /// Address Section
                                        _buildExpandableSection(
                                          icon: Icons.location_on_outlined,
                                          title: "Address",
                                          color: Colors.blueAccent,
                                          content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildCompactTextRow("Property Address :", abc.data![0].propertyNameAddress),
                                              const SizedBox(height: 6),
                                              _buildCompactTextRow("Field Worker Address: ", abc.data![0].propertyAddressForFieldworker),
                                              const SizedBox(height: 6),
                                              InkWell(
                                                onTap: () async {
                                                  final address = abc.data![0].yourAddress;
                                                  final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$address");

                                                  if (await canLaunchUrl(url)) {
                                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                },
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                              text: "Current Location: ",
                                                              style: TextStyle(
                                                                fontFamily: "Poppins",
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: abc.data![0].yourAddress,
                                                              style: const TextStyle(
                                                                color: Colors.blue,
                                                                fontFamily: "Poppins",
                                                                decoration: TextDecoration.underline,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )

                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        /// Property Details Grid
                                        _buildCompactSection(
                                          icon: Icons.info_outline,
                                          title: "Details",
                                          color: Colors.green,
                                          children: [
                                            _buildCompactSection(
                                              icon: Icons.location_city,
                                              title: "Localities",
                                              color: Colors.deepOrange,
                                              children: [
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: localityChips.map((loc) {
                                                    return Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness == Brightness.dark
                                                            ? Colors.white12
                                                            : Colors.orange.shade50,
                                                        borderRadius: BorderRadius.circular(14),
                                                        border: Border.all(color: Colors.deepOrange),
                                                      ),
                                                      child: Text(
                                                        loc,
                                                        style: TextStyle(
                                                          color: Theme.of(context).brightness == Brightness.dark
                                                              ? Colors.orange.shade600
                                                              : Colors.deepOrange.shade800,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 220,
                                                childAspectRatio: 3.2,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                              ),
                                              itemCount: 8,
                                              itemBuilder: (context, index) {
                                                final details = [
                                                  ["Floors", abc.data![0].totalFloor],
                                                  ["Road Size", abc.data![0].roadSize],
                                                  ["Metro", abc.data![0].metroName],
                                                  ["Metro Dist", abc.data![0].metroDistance],
                                                  ["Market Dist", abc.data![0].mainMarketDistance],
                                                  ["Age", abc.data![0].ageOfProperty],
                                                  ["Lift", abc.data![0].lift],
                                                  ["Parking", abc.data![0].parking],
                                                ];
                                                return _buildCompactDetailItem(details[index][0], details[index][1]);
                                              },
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Added: ${abc.data![0].currentDate ?? '-'}",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
                                              ),
                                            ),

                                            Text(
                                              "ID: ${abc.data![0].id}",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
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
                        }
                      }
                  );
                },
                childCount: 1, // Number of categories
              ),
            ),


            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return FutureBuilder<List<DocumentMainModel_F>>(
                    future: fetchCarouselData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 30,),
                              Text(
                                "No Multiple Images Found",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 500,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.9,
                                aspectRatio: 16 / 9,
                                initialPage: 0,
                              ),
                              items: snapshot.data!.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PropertyPreview(
                                              ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                            ),
                                          ),
                                        );

                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Image.asset(
                                              AppImages.loading,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget: (context, error, stackTrace) =>
                                                Image.asset(
                                                  AppImages.imageNotFound,
                                                  fit: BoxFit.cover,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                          ],
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),


          ],
        ),
      ),

        bottomNavigationBar: FutureBuilder<Map<String, dynamic>>(
          future: _fetchAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            else if (snapshot.data == null ||
                (snapshot.data!['catidList'] as List).isEmpty) {
              // If the list is empty, show empty message
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "No Data Found!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              final catidList = snapshot.data!['catidList'] as List<FutureProperty2>;

              return ListView.builder(
                itemCount: 1, // only first element like before
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int len) {
                  print('apartment address: ${catidList[len].propertyNameAddress}');
                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),

                      onPressed: () {
                        final data = catidList[len];
                        if (data.roadSize.isEmpty ||
                            data.metroName.isEmpty ||
                            data.metroDistance.isEmpty ||
                            data.mainMarketDistance.isEmpty ||
                            data.ageOfProperty.isEmpty ||
                            data.lift.isEmpty ||
                            data.parking.isEmpty) {
                          // Show red snackbar warning
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "⚠ Please update property details before adding flats.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              duration: Duration(seconds: 10), // longer visibility
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return; // stop navigation
                        }

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //       "✔ ALL Building details are updated",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     duration: Duration(seconds: 3), // longer visibility
                        //     backgroundColor: Colors.green,
                        //     behavior: SnackBarBehavior.floating,
                        //   ),
                        // );

                        print('id: ${widget.idd}');
                        print('Owner_name: ${data.ownerName}');
                        print('Owner_num: ${data.ownerNumber}');
                        print('Caretaker_name: ${data.caretakerName}');
                        print('Caretaker_num: ${data.caretakerNumber}');
                        print('market_dis: ${data.mainMarketDistance}');
                        print('metro_name: ${data.metroName}');
                        print('metro_dis: ${data.metroDistance}');
                        print('road_size: ${data.roadSize}');
                        print('age_property: ${data.ageOfProperty}');
                        print('apartment_address: ${data.propertyNameAddress}');
                        print('apartment_name: ${data.propertyNameAddress}');
                        print('field_address: ${data.propertyAddressForFieldworker}');
                        print('current_loc: ${data.currentDate}');
                        print('place: ${data.place}');
                        print('lift: ${data.lift}');
                        print('totalFloor: ${data.totalFloor}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Add_Flatunder_futureproperty(
                              id: widget.idd,
                              Owner_name: data.ownerName,
                              Owner_num: data.ownerNumber,
                              Caretaker_name: data.caretakerName,
                              Caretaker_num: data.caretakerNumber,
                              market_dis: data.mainMarketDistance,
                              metro_name: data.metroName,
                              metro_dis: data.metroDistance,
                              road_size: data.roadSize,
                              age_property: data.ageOfProperty,
                              apartment_address: data.propertyNameAddress,
                              field_address: data.propertyAddressForFieldworker,
                              current_loc: data.currentDate,
                              place: data.place,
                              lift: data.lift,
                              totalFloor: data.totalFloor,
                              Residence_commercial: data.residenceCommercial,
                              facility: data.facility,
                              google_loc: data.yourAddress,
                              locality_list: data.localitiesList,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Add Flats',
                        style: TextStyle(fontSize: 15,color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
      );
  }

  Widget _buildCompactSection({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children
  }) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: children,
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required Color color,
    required Widget content
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        content,
      ],
    );
  }
  Widget _buildCompactChip({
    required IconData icon,
    required String text,
    required Color color,       // background color
    required Color borderColor, // border color
    required Color shadowColor, // new: shadow color
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5), // dynamic shadow color
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        color: color, // chip background
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }



  void _showCallDialog(BuildContext context, String number, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Call $type"),
        content: Text('Do you want to call $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FlutterPhoneDirectCaller.callNumber(number);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
  Widget _buildCompactTextRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Poppins"),
          ),
          TextSpan(
            text: value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCompactDetailItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // more space
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white12
            : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 15, // bigger text
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color:
                Theme.of(context).brightness==Brightness.dark?
                Colors.white:
                Colors.black,
                // shadows: [
                //   Shadow(
                //     blurRadius: 1,
                //     // offset: Offset(2, 2),
                //     color: Theme.of(context).brightness == Brightness.dark
                //         ? Colors.amber
                //         : Colors.black87,
                //   )
                // ],
                fontSize: 15, // bigger text
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  void _showContactDialog(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Contact Owner"),
        content: Text('Would you like to contact $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Image.asset(AppImages.whatsaap, height: 36, width: 36),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    String url = 'whatsapp://send?phone=91$number&text=Hello';
                    await launchUrl(Uri.parse(url));
                  } else {
                    String url = 'https://wa.me/$number';
                    await launchUrl(Uri.parse(url));
                  }
                },
              ),
              IconButton(
                icon: Image.asset(AppImages.call, height: 36, width: 36),
                onPressed: () {
                  Navigator.of(context).pop();
                  FlutterPhoneDirectCaller.callNumber(number);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildInfoChip({
    required String text,
    required Color borderColor,
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor, // new: optional shadow color
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? borderColor).withOpacity(0.4), // default to borderColor
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13, // slightly bigger
          fontWeight: FontWeight.bold,
          color:
          Theme.of(context).brightness==Brightness.dark?
          Colors.white:Colors.black?? Colors.black,
        ),
      ),
    );
  }

}
