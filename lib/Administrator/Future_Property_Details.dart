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
import '../constant.dart';
import '../model/futureProperty_Slideer.dart';
import 'Add_Assign_Tenant_Demand/Admin_under_flats.dart';
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
                          children: [
                            const SizedBox(height: 20,),
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
                          ],
                        ),
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
