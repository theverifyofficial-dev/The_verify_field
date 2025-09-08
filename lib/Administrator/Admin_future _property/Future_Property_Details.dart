import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant.dart';
import '../../model/futureProperty_Slideer.dart';
import 'Admin_under_flats.dart';
import '../Update_Future_Property.dart';
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
  final String apartmentName; // optional
  final String facility;
  final String currentLocation; // optional
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
      id: json['id'] ?? 0,
      images: json['images']?.toString() ?? '',
      ownerName: json['ownername']?.toString() ?? '',
      ownerNumber: json['ownernumber']?.toString() ?? '',
      caretakerName: json['caretakername']?.toString() ?? '',
      caretakerNumber: json['caretakernumber']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      buyRent: json['buy_rent']?.toString() ?? '',
      typeOfProperty: json['typeofproperty']?.toString() ?? '',
      selectBhk: json['select_bhk']?.toString() ?? '',
      floorNumber: json['floor_number']?.toString() ?? '',
      squareFeet: json['sqyare_feet']?.toString() ?? '',
      propertyNameAddress: json['propertyname_address']?.toString() ?? '',
      buildingInformationFacilities: json['building_information_facilitys']?.toString() ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar']?.toString() ?? '',
      ownerVehicleNumber: json['owner_vehical_number']?.toString() ?? '',
      yourAddress: json['your_address']?.toString() ?? '',
      fieldworkerName: json['fieldworkarname']?.toString() ?? '',
      fieldworkerNumber: json['fieldworkarnumber']?.toString() ?? '',
      currentDate: json['current_date_']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      metroName: json['metro_name']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      totalFloor: json['total_floor']?.toString() ?? '',
      apartmentName: json['apartment_name']?.toString() ?? '',
      facility: json['facility']?.toString() ?? '',
      currentLocation: json['current_location']?.toString() ?? '',
      residenceCommercial: json['Residence_commercial']?.toString() ?? '',
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
      'current_location': currentLocation,
      'Residence_commercial': residenceCommercial,
    };
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
  // final String videoLink;
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
    // required this.videoLink,
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
      // videoLink: json['video_link'] ?? '',
      fieldWorkerLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid'] ?? '',
    );
  }
}


class Administater_Future_Property_details extends StatefulWidget {
  String idd;
  Administater_Future_Property_details({super.key, required this.idd});

  @override
  State<Administater_Future_Property_details> createState() => _Administater_Future_Property_detailsState();
}

class _Administater_Future_Property_detailsState extends State<Administater_Future_Property_details> {




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

  Future<List<FutureProperty2>> fetchData(id_num) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=$id_num");
    print(id_num);
    final responce = await http.get(url);
    print("Response body of fetch flat data: ${responce.body}");
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
    if (!mounted) return;
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    }
    );

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
        surfaceTintColor: Colors.black,
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
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

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
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),

                            Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white12
                                  : Colors.grey.shade200,
                              child: Container(
                                padding: const EdgeInsets.all(16), // slightly more padding
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    /// Property Type Tags
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        _buildInfoChip(
                                          text: abc.data![len].place,
                                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.green.shade50,
                                          textColor: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.green.shade800,
                                          borderColor: Colors.green,
                                        ),
                                        _buildInfoChip(
                                          text: abc.data![len].residenceCommercial,
                                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.blue.withOpacity(0.2)
                                              : Colors.blue.shade50,
                                          textColor: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.blue.shade200
                                              : Colors.blue.shade800,
                                          borderColor: Colors.blue,
                                        ),
                                        _buildInfoChip(
                                          text: abc.data![len].buyRent,
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

                                    const SizedBox(height: 10), // more gap before divider
                                    Divider(height: 1, color: Theme.of(context).dividerColor),
                                    const SizedBox(height: 10),

                                    /// Owner Info
                                    _buildCompactSection(
                                      icon: Icons.person_outline,
                                      title: "Owner Info",
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      children: [
                                        _buildCompactChip(
                                          icon: Icons.person,
                                          text: abc.data![len].ownerName,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.grey.shade200,
                                          borderColor: Colors.deepPurpleAccent,
                                          shadowColor: Colors.deepPurpleAccent
                                        ),
                                        GestureDetector(
                                          onTap: () => _showContactDialog(context, abc.data![len].ownerNumber),
                                          child: _buildCompactChip(
                                            icon: Icons.phone,
                                            text: abc.data![len].ownerNumber,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.grey.shade200,
                                              borderColor: Colors.deepPurpleAccent,
                                              shadowColor: Colors.deepPurpleAccent
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildCompactChip(
                                          icon: Icons.directions_car,
                                          text: abc.data![len].ownerVehicleNumber,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.grey.shade200,
                                            borderColor: Colors.cyan,
                                            shadowColor: Colors.cyan
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10), // extra space before Caretaker

                                    /// Caretaker
                                    _buildCompactSection(
                                      icon: Icons.support_agent,
                                      title: "Caretaker",
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      children: [
                                        _buildCompactChip(
                                          borderColor: Colors.blue,
                                          shadowColor: Colors.blue,
                                          icon: Icons.person,
                                          text: abc.data![len].caretakerName,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.grey.shade200,
                                        ),
                                        const SizedBox(width: 25),
                                        GestureDetector(
                                          onTap: () => _showCallDialog(
                                            context,
                                            abc.data![len].caretakerNumber,
                                            "Caretaker",
                                          ),
                                          child: _buildCompactChip(
                                            icon: Icons.phone,
                                            text: abc.data![len].caretakerNumber,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Colors.grey.shade200,
                                              borderColor: Colors.blue,
                                              shadowColor: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20), // extra space before Address

                                    /// Address Section
                                    _buildExpandableSection(
                                      icon: Icons.location_on_outlined,
                                      title: "Address",
                                      color: Colors.blueAccent,
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildCompactTextRow("Property:", abc.data![len].propertyNameAddress),
                                          const SizedBox(height: 6),
                                          _buildCompactTextRow("Field:", abc.data![len].propertyAddressForFieldworker),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20), // gap before Details

                                    /// Property Details Grid
                                    _buildCompactSection(
                                      icon: Icons.info_outline,
                                      title: "Details",
                                      color: Colors.green,
                                      children: [
                                        GridView.count(
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          childAspectRatio: 3.2,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                          children: [
                                            _buildCompactDetailItem("Floors", abc.data![len].totalFloor),
                                            _buildCompactDetailItem("Road Size", abc.data![len].roadSize),
                                            _buildCompactDetailItem("Metro", abc.data![len].metroName),
                                            _buildCompactDetailItem("Metro Dist", abc.data![len].metroDistance),
                                            _buildCompactDetailItem("Market Dist", abc.data![len].mainMarketDistance),
                                            _buildCompactDetailItem("Age", abc.data![len].ageOfProperty),
                                            _buildCompactDetailItem("Lift", abc.data![len].lift),
                                            _buildCompactDetailItem("Parking", abc.data![len].parking),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 20), // bigger gap before footer

                                    /// Footer
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Added: ${(() {
                                                    final s = abc.data![len].currentDate?.toString() ?? '';
                                                    if (s.isEmpty) return '-';
                                                    try {

                                                      final dt = DateFormat('yyyy-MM-dd hh:mm a').parse(s);
                                                      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                                                    } catch (_) {
                                                      try {
                                                        final dt2 = DateTime.parse(s);
                                                        return DateFormat('dd MMM yyyy, hh:mm a').format(dt2);
                                                      } catch (_) {
                                                        return s;
                                                      }
                                                    }
                                                  })()}",
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                                Text(
                                          "ID: ${abc.data![len].id}",
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
                        )

                      );
                    });
              }


            }

        ),
                    FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
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
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );
                                            print(abc.data![len].subid);
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(" "+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text(""+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                            ],
                                                          )



                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },

                    ),

                  FutureBuilder<List<Ground>>(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'First Floor',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context, int len) {
                                    return Column(
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
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );
                                            print("${abc.data![len].id
                                                .toString()}");
                                            print("${abc.data![len].id}");
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 0),
                                                child: Container(

                                                  padding: const EdgeInsets.all(
                                                      10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                    .circular(
                                                                    10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 120,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/" +
                                                                        abc
                                                                            .data![len]
                                                                            .propertyPhoto,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder: (
                                                                        context,
                                                                        url) =>
                                                                        Image
                                                                            .asset(
                                                                          AppImages
                                                                              .loading,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                    errorWidget: (
                                                                        context,
                                                                        error,
                                                                        stack) =>
                                                                        Image
                                                                            .asset(
                                                                          AppImages
                                                                              .imageNotFound,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text(
                                                                    "Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    width: 110,
                                                                    child: Text(
                                                                      " " + abc
                                                                          .data![len]
                                                                          .flatNumber,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
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
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text(
                                                                    "Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    child: Text(
                                                                      "" + abc
                                                                          .data![len]
                                                                          .floor,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
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
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    width: 110,
                                                                    child: Text(
                                                                      "" + abc
                                                                          .data![len]
                                                                          .availableDate,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                            ],
                                                          )


                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .typeOfProperty /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .locations /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .buyRent /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }
              ),

                 FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
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
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );
                                            print(" Sub ID : ${abc.data![len].subid.toString()}");
                                            print("ID : ${abc.data![len].id.toString()}");
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(" "+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text(""+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                            ],
                                                          )



                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // ElevatedButton(
                                              //   style: ElevatedButton.styleFrom(
                                              //     backgroundColor: Colors.deepPurple, // button background color
                                              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius: BorderRadius.circular(12), // rounded corners
                                              //     ),
                                              //     elevation: 5,
                                              //     shadowColor: Colors.deepPurpleAccent,
                                              //   ),
                                              //   onPressed: () async {
                                              //     final int propertyId = abc.data![len].id;
                                              //
                                              //     final url = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/dublicate_data.php');
                                              //
                                              //     try {
                                              //       final response = await http.post(
                                              //         url,
                                              //         body: {'P_id': propertyId.toString()},
                                              //       );
                                              //
                                              //       if (response.statusCode == 200) {
                                              //         print('API response: ${response.body}');
                                              //         ScaffoldMessenger.of(context).showSnackBar(
                                              //           const SnackBar(content: Text('Duplicate request sent successfully!')),
                                              //         );
                                              //       } else {
                                              //         print('Failed to send data: ${response.statusCode}');
                                              //         ScaffoldMessenger.of(context).showSnackBar(
                                              //           const SnackBar(content: Text('Failed to send duplicate request')),
                                              //         );
                                              //       }
                                              //     } catch (e) {
                                              //       print('Error sending data: $e');
                                              //       ScaffoldMessenger.of(context).showSnackBar(
                                              //         const SnackBar(content: Text('Error occurred while sending request')),
                                              //       );
                                              //     }
                                              //   },
                                              //   child: const Text(
                                              //     'Duplicate',
                                              //     style: TextStyle(
                                              //       fontSize: 16,
                                              //       fontWeight: FontWeight.bold,
                                              //       color: Colors.white,
                                              //       letterSpacing: 1.2,
                                              //     ),
                                              //   ),
                                              // )


                                            ],
                                          ),
                                        ),


                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    FutureBuilder<List<Ground>>(
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
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Third Floor',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context, int len) {
                                    return Column(
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
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 0),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                      10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                    .circular(
                                                                    10)),
                                                                child: Container(
                                                                  height: 100,
                                                                  width: 120,
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/" +
                                                                        abc
                                                                            .data![len]
                                                                            .propertyPhoto,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder: (
                                                                        context,
                                                                        url) =>
                                                                        Image
                                                                            .asset(
                                                                          AppImages
                                                                              .loading,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                    errorWidget: (
                                                                        context,
                                                                        error,
                                                                        stack) =>
                                                                        Image
                                                                            .asset(
                                                                          AppImages
                                                                              .imageNotFound,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text(
                                                                    "Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    width: 110,
                                                                    child: Text(
                                                                      " " + abc
                                                                          .data![len]
                                                                          .flatNumber,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
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
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text(
                                                                    "Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    child: Text(
                                                                      "" + abc
                                                                          .data![len]
                                                                          .floor,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 2,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
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
                                                                  Icon(
                                                                    PhosphorIcons
                                                                        .address_book,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(
                                                                    width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
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
                                                                    width: 110,
                                                                    child: Text(
                                                                      "" + abc
                                                                          .data![len]
                                                                          .availableDate,
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w400
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                            ],
                                                          )


                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .typeOfProperty /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .locations /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                                            padding: EdgeInsets
                                                                .only(left: 10,
                                                                right: 10,
                                                                top: 0,
                                                                bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(5),
                                                              border: Border
                                                                  .all(width: 1,
                                                                  color: Colors
                                                                      .blue),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .blue
                                                                        .withOpacity(
                                                                        0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(
                                                                        0, 0),
                                                                    blurStyle: BlurStyle
                                                                        .outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text("" + abc
                                                                    .data![len]
                                                                    .buyRent /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight: FontWeight
                                                                          .w500,
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
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }
                ),

                    FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
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
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(" "+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text("Floor Number"+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),

                                                            ],
                                                          )



                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            print("'${abc.data![len].id}'");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text(""+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                            child: Column(
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
                                                            child:
                                                            Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5
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
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                            ],
                          );
                        }
                      },
              ),
                  FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            print("'${abc.data![len].id}'");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );

                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text(""+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                            child: Column(
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
                                                            child:
                                                            Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5
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
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },

              ),
                FutureBuilder<List<Ground>>(
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
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,int len) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            //  int itemId = abc.data![len].id;
                                            //int iiid = abc.data![len].PropertyAddress
                                            /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('id_Document', abc.data![len].id.toString());*/
                                            print("'${abc.data![len].id}'");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute
                                                  (builder: (context) => Admin_underflat_futureproperty(id: '${abc.data![len].id}',Subid: '${abc.data![len].subid}',))
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
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
                                                                  height: 100,
                                                                  width: 120,
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
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Property no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text("Flat Number"+abc.data![len].flatNumber,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Floor no",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    child: Text(""+abc.data![len].floor,
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
                                                                height: 5,
                                                              ),

                                                              Row(
                                                                children: [
                                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("Date",
                                                                    style: TextStyle(
                                                                        fontSize: 13,
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
                                                                    width: 110,
                                                                    child: Text(""+abc.data![len].availableDate,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 4,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),

                                                      SizedBox(height: 6,),

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
                                                            child: Column(
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
                                                            child:
                                                            Text(""+abc.data![len].buyRent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5
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
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                            ],
                          );
                        }
                      },

              ),
            ],
          ),

        ),
      ),
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
          spacing: 6,
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
        style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyLarge?.color),
        children: [
          TextSpan(
            text: "$label ",
            style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Poppins"),
          ),
          TextSpan(
            text: value,
            style: TextStyle(fontSize: 13),
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
